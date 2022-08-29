#!/usr/bin/python3
# -*- coding: utf-8 -*-

# Copyright: (c) 2018
# Kushal Das <mail@kushaldas.in>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = '''
---
module: qubesos
short_description: Manages virtual machines supported by QubesOS
description:
     - Manages virtual machines supported by I(libvirt).
version_added: "2.8"
options:
  name:
    description:
      - name of the guest VM being managed. Note that VM must be previously
        defined with xml.
      - This option is required unless I(command) is C(list_vms).
  state:
    description:
      - Note that there may be some lag for state requests like C(shutdown)
        since these refer only to VM states. After starting a guest, it may not
        be immediately accessible.
    choices: [ destroyed, paused, running, shutdown ]
  command:
    description:
      - In addition to state management, various non-idempotent commands are available.
    choices: [ create, define, destroy,  info, list_vms, pause, shutdown, start, status, stop, unpause ]
  autostart:
    description:
      - start VM at host startup.
    type: bool
    version_added: "2.3"
  uri:
    description:
      - libvirt connection uri.
    default: qemu:///system
  xml:
    description:
      - XML document used with the define command.
      - Must be raw XML content using C(lookup). XML cannot be reference to a file.
requirements:
    - python >= 2.6
    - libvirt-python
author:
    - Ansible Core Team
    - Michael DeHaan
    - Seth Vidal
'''

EXAMPLES = '''
# a playbook task line:
- virt:
    name: alpha
    state: running
# /usr/bin/ansible invocations
# ansible host -m virt -a "name=alpha command=status"
# ansible host -m virt -a "name=alpha command=get_xml"
# ansible host -m virt -a "name=alpha command=create uri=lxc:///"
---
# a playbook example of defining and launching an LXC guest
tasks:
  - name: define vm
    virt:
        name: foo
        command: define
        xml: "{{ lookup('template', 'container-template.xml.j2') }}"
        uri: 'lxc:///'
  - name: start vm
    virt:
        name: foo
        state: running
        uri: 'lxc:///'
'''

RETURN = '''
# for list_vms command
list_vms:
    description: The list of vms defined on the remote system
    type: dictionary
    returned: success
    sample: [
        "build.example.org",
        "dev.example.org"
    ]
# for status command
status:
    description: The status of the VM, among running, crashed, paused and shutdown
    type: string
    sample: "success"
    returned: success
'''

import time
import traceback

try:
    import qubesadmin
    from qubesadmin.exc import QubesVMNotStartedError, QubesTagNotFoundError
    from jinja2 import Template
except ImportError:
    HAS_QUBES = False
else:
    HAS_QUBES = True

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_native


VIRT_FAILED = 1
VIRT_SUCCESS = 0
VIRT_UNAVAILABLE = 2

ALL_COMMANDS = []
VM_COMMANDS = ['create', 'destroy', 'pause', 'shutdown', 'status', 'start', 'stop', 'unpause', 'removetags']
HOST_COMMANDS = ['info', 'list_vms', 'get_states', 'createinventory']
ALL_COMMANDS.extend(VM_COMMANDS)
ALL_COMMANDS.extend(HOST_COMMANDS)

VIRT_STATE_NAME_MAP = {
    0: 'running',
    1: 'paused',
    4: 'shutdown',
    5: 'shutdown',
    6: 'crashed',
}

PROPS = {'autostart': bool,
         'debug': bool,
         'include_in_backups': bool,
         'kernel': str,
         'label': str,
         'maxmem': int,
         'memory': int,
         'provides_network': bool,
         'template': str,
         'template_for_dispvms': bool,
         'vcpus': int,
         'virt_mode': str,
         'default_dispvm': str,
         'netvm': str,
         'features': dict,
         'volume': dict,
        }


def create_inventory(result):
    "Creates the inventory file dynamically for QubesOS"
    template_str = """[local]
localhost
[local:vars]
ansible_connection=local
[appvms]
{% for item in result.AppVM %}
{{ item -}}
{% endfor %}
[templatevms]
{% for item in result.TemplateVM %}
{{ item -}}
{% endfor %}
[standalonevms]
{% for item in result.StandaloneVM %}
{{ item -}}
{% endfor %}
[appvms:vars]
ansible_connection=qubes
[templatevms:vars]
ansible_connection=qubes
[standalone:vars]
ansible_connection=qubes
"""
    template = Template(template_str)
    res = template.render(result=result)
    with open("inventory", "w") as fobj:
        fobj.write(res)


class QubesVirt(object):

    def __init__(self, module):
        self.module = module
        self.app = qubesadmin.Qubes()

    def get_vm(self, vmname):
        return self.app.domains[vmname]

    def __get_state(self, domain):
        vm = self.app.domains[domain]
        if vm.is_paused():
            return "paused"
        if vm.is_running():
            return "running"
        if vm.is_halted():
            return "shutdown"

    def get_states(self):
        state = []
        for vm in self.app.domains:
            state.append("%s %s" % (vm.name, self.__get_state(vm.name)))
        return state

    def list_vms(self, state):
        res = []
        for vm in self.app.domains:
            if vm.name != "dom0" and state == self.__get_state(vm.name):
                res.append("%s" % vm.name)
        return res

    def all_vms(self):
        res = {}
        for vm in self.app.domains:
            if vm.name != "dom0":
                res.setdefault(vm.klass, []).append(vm.name)
        return res

    def info(self):
        info = dict()
        for vm in self.app.domains:
            if vm.name == "dom0":
                continue
            info[vm.name] = dict(
                state=self.__get_state(vm),
                provides_network=vm.provides_network,
                label=vm.label.name,
            )

        return info


    def shutdown(self, vmname):
        """ Make the machine with the given vmname stop running.  Whatever that takes.  """
        vm = self.get_vm(vmname)
        vm.shutdown()
        return 0

    def pause(self, vmname):
        """ Pause the machine with the given vmname.  """

        vm = self.get_vm(vmname)
        vm.pause()
        return 0

    def unpause(self, vmname):
        """ Unpause the machine with the given vmname.  """

        vm = self.get_vm(vmname)
        vm.unpause()
        return 0

    def create(self, vmname, vmtype="AppVM", label="red", template=None, netvm="default"):
        """ Start the machine via the given vmid """
        network_vm = None
        template_vm = ""
        if template:
            template_vm = template
        if netvm == "default":
            network_vm = self.app.default_netvm
        elif not netvm:
            network_vm = None
        else:
            network_vm = self.get_vm(netvm)
        if vmtype == "AppVM":
            vm = self.app.add_new_vm(vmtype, vmname, label, template=template_vm)
            vm.netvm = network_vm
        elif vmtype in ["StandaloneVM", "TemplateVM"] and template_vm:
            vm = self.app.clone_vm(template_vm, vmname, vmtype)
            vm.label = label
        return 0

    def start(self, vmname):
        """ Start the machine via the given id/name """

        vm = self.get_vm(vmname)
        vm.start()
        return 0

    def destroy(self, vmname):
        """ Pull the virtual power from the virtual domain, giving it virtually no time to virtually shut down.  """

        vm = self.get_vm(vmname)
        vm.force_shutdown()
        return 0

    def properties(self, vmname, prefs, vmtype, label, vmtemplate):
        "Sets the given properties to the VM"
        changed = False
        vm = None
        values_changed = []
        try:
            vm = self.get_vm(vmname)
        except KeyError:
            # Means first we have to create the vm
            self.create(vmname, vmtype, label, vmtemplate)
            vm = self.get_vm(vmname)
        if "autostart" in prefs and vm.autostart != prefs["autostart"]:
            vm.autostart = prefs["autostart"]
            changed = True
            values_changed.append("autostart")
        if "debug" in prefs and vm.debug != prefs["debug"]:
            vm.debug = prefs["debug"]
            changed = True
            values_changed.append("debug")
        if "include_in_backups" in prefs and vm.include_in_backups != prefs["include_in_backups"]:
            vm.include_in_backups = prefs["include_in_backups"]
            changed = True
            values_changed.append("include_in_backups")
        if "kernel" in prefs and vm.kernel != prefs["kernel"]:
            vm.kernel = prefs["kernel"]
            changed = True
            values_changed.append("kernel")
        if "label" in prefs and vm.label.name != prefs["label"]:
            vm.label = prefs["label"]
            changed = True
            values_changed.append("label")
        if "maxmem" in prefs and vm.maxmem != prefs["maxmem"]:
            vm.maxmem = prefs["maxmem"]
            changed = True
            values_changed.append("maxmem")
        if "memory" in prefs and vm.memory != prefs["memory"]:
            vm.memory = prefs["memory"]
            changed = True
            values_changed.append("memory")
        if "provides_network" in prefs and vm.provides_network != prefs["provides_network"]:
            vm.provides_network = prefs["provides_network"]
            changed = True
            values_changed.append("provides_network")
        if "netvm" in prefs:
            # To make sure that we allow VMs with netvm
            if prefs["netvm"] == "":
                netvm = ""
            else:
                netvm = self.app.domains[prefs["netvm"]]
            if vm.netvm != netvm:
                vm.netvm = netvm
                changed = True
                values_changed.append("netvm")
        if "default_dispvm" in prefs:
            default_dispvm = self.app.domains[prefs["default_dispvm"]]
            if vm.default_dispvm != default_dispvm:
                vm.default_dispvm = default_dispvm
                changed = True
                values_changed.append("default_dispvm")
        if "template" in prefs:
            template = self.app.domains[prefs["template"]]
            if vm.template != template:
                vm.template = template
                changed = True
                values_changed.append("template")
        if "template_for_dispvms" in prefs and vm.template_for_dispvms != prefs["template_for_dispvms"]:
            vm.template_for_dispvms = prefs["template_for_dispvms"]
            changed = True
            values_changed.append("template_for_dispvms")
        if "vcpus" in prefs and vm.vcpus != prefs["vcpus"]:
            vm.vcpus = prefs["vcpus"]
            changed = True
            values_changed.append("vcpus")
        if "virt_mode" in prefs and vm.virt_mode != prefs["virt_mode"]:
            vm.virt_mode = prefs["virt_mode"]
            changed = True
            values_changed.append("virt_mode")
        if "features" in prefs:
            did_feature_changed = False
            for key, value in prefs["features"].items():
                if value == "" and key in vm.features:
                    vm.features[key] = ""
                    changed = True
                    did_feature_changed = True
                elif value == "None" and key in vm.features:
                    del vm.features[key]
                    changed = True
                    did_feature_changed = True
                elif key in vm.features and value != vm.features[key]:
                    vm.features[key] = value
                    changed = True
                    did_feature_changed = True
                elif not key in vm.features and value != "None":
                    vm.features[key] = value
                    changed = True
                    did_feature_changed = True
            if did_feature_changed:
                values_changed.append("features")
        if "volume" in prefs:
            val = prefs["volume"]
            # Let us get the volume
            try:
                volume = vm.volumes[val["name"]]
                volume.resize(val["size"])
            except Exception:
                return VIRT_FAILED, {"Failure in updating volume": val}
            changed = True
            values_changed.append("volume")

        return changed, values_changed


    def undefine(self, vmname):
        """ Stop a domain, and then wipe it from the face of the earth.  (delete disk/config file) """
        try:
            self.destroy(vmname)
        except QubesVMNotStartedError:
            pass
            # Because it is not running

        while True:
            if self.__get_state(vmname) == "shutdown":
                break
            time.sleep(1)
        del self.app.domains[vmname]
        return 0

    def status(self, vmname):
        """
        Return a state suitable for server consumption.  Aka, codes.py values, not XM output.
        """
        return self.__get_state(vmname)

    def tags(self, vmname, tags):
        "Adds a list of tags to the vm"
        vm = self.get_vm(vmname)
        for tag in tags:
            vm.tags.add(tag)
        return 0


def core(module):

    state = module.params.get('state', None)
    guest = module.params.get('name', None)
    command = module.params.get('command', None)
    vmtype = module.params.get('vmtype', 'AppVM')
    label = module.params.get('label', 'red')
    template = module.params.get('template', None)
    properties = module.params.get('properties', {})
    tags = module.params.get('tags', [])

    v = QubesVirt(module)
    res = dict()

    # properties will only work with state=present
    if properties:
        for key,val in properties.items():
            if not key in PROPS:
                return VIRT_FAILED, {"Invalid property": key}
            if type(val) != PROPS[key]:
                return VIRT_FAILED, {"Invalid property value type": key}
            # Make sure that the netvm exists
            if key == "netvm" and val != "":
                try:
                    vm = v.get_vm(val)
                except KeyError:
                    return VIRT_FAILED, {"Missing netvm": val}
                # Also the vm should provide network
                if not vm.provides_network:
                    return VIRT_FAILED, {"Missing netvm capability": val}

            # Make sure volume has both name and value
            if key == "volume":
                if "name" not in val:
                    return VIRT_FAILED, {"Missing name for the volume": val}
                elif "size" not in val:
                    return VIRT_FAILED, {"Missing size for the volume": val}

                allowed_name = []
                if vmtype == 'AppVM':
                    allowed_name.append("private")
                elif vmtype in ["StandAloneVM", "TemplateVM"]:
                    allowed_name.append("root")

                if not val["name"] in allowed_name:
                    return VIRT_FAILED, {"Wrong volume name": val}

            # Make sure that the default_dispvm exists
            if key == "default_dispvm":
                try:
                    vm = v.get_vm(val)
                except KeyError:
                    return VIRT_FAILED, {"Missing default_dispvm": val}
                # Also the vm should provide network
                if not vm.template_for_dispvms:
                    return VIRT_FAILED, {"Missing dispvm capability": val}
        if state == "present" and guest and vmtype:
            changed, changed_values = v.properties(guest, properties, vmtype, label, template)
            if tags:
                # Apply the tags
                v.tags(guest, tags)
            return VIRT_SUCCESS, {"Properties updated": changed_values, "changed": changed}

    # This is without any properties
    if state == "present" and guest and vmtype:
        try:
            v.get_vm(guest)
            res = {"changed": False, "status": "VM is present."}
        except KeyError:
            v.create(guest, vmtype, label, template)
            if tags:
                # Apply the tags
                v.tags(guest, tags)
            res = {'changed': True, 'created': guest}
        return VIRT_SUCCESS, res

    if state and command == 'list_vms':
        res = v.list_vms(state=state)
        if not isinstance(res, dict):
            res = {command: res}
        return VIRT_SUCCESS, res

    if command == "get_states":
        states = v.get_states()
        res = {"states": states}
        return VIRT_SUCCESS, res

    if command == "createinventory":
        result = v.all_vms()
        create_inventory(result)
        return VIRT_SUCCESS, {"status": "successful"}

    if command:
        if command in VM_COMMANDS:
            if not guest:
                module.fail_json(msg="%s requires 1 argument: guest" % command)
            if command == 'create':
                # if not xml:
                #     module.fail_json(msg="define requires xml argument")
                try:
                    v.get_vm(guest)
                except KeyError:
                    v.create(guest, vmtype, label, template, netvm)
                    res = {'changed': True, 'created': guest}
                return VIRT_SUCCESS, res
            elif command == 'removetags':
                vm = v.get_vm(guest)
                changed = False
                if not tags:
                    return VIRT_FAILED, {"Error": "Missing tag(s) to remove."}
                for tag in tags:
                    try:
                        vm.tags.remove(tag)
                        changed = True
                    except QubesTagNotFoundError:
                        pass
                return VIRT_SUCCESS, {"Message": "Removed the tag(s).", "changed": changed}
            res = getattr(v, command)(guest)
            if not isinstance(res, dict):
                res = {command: res}
            return VIRT_SUCCESS, res

        elif hasattr(v, command):
            res = getattr(v, command)()
            if not isinstance(res, dict):
                res = {command: res}
            return VIRT_SUCCESS, res

        else:
            module.fail_json(msg="Command %s not recognized" % command)

    if state:
        if not guest:
            module.fail_json(msg="state change requires a guest specified")

        if state == 'running':
            if v.status(guest) is 'paused':
                res['changed'] = True
                res['msg'] = v.unpause(guest)
            elif v.status(guest) is not 'running':
                res['changed'] = True
                res['msg'] = v.start(guest)
        elif state == 'shutdown':
            if v.status(guest) is not 'shutdown':
                res['changed'] = True
                res['msg'] = v.shutdown(guest)
        elif state == 'destroyed':
            if v.status(guest) is not 'shutdown':
                res['changed'] = True
                res['msg'] = v.destroy(guest)
        elif state == 'paused':
            if v.status(guest) is 'running':
                res['changed'] = True
                res['msg'] = v.pause(guest)
        elif state == 'undefine':
            if v.status(guest) is not 'shutdown':
                res['changed'] = True
                res['msg'] = v.undefine(guest)
        else:
            module.fail_json(msg="unexpected state")

        return VIRT_SUCCESS, res


    module.fail_json(msg="expected state or command parameter to be specified")


def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='str', aliases=['guest']),
            state=dict(type='str', choices=['destroyed', 'pause', 'running', 'shutdown', 'undefine', 'present']),
            command=dict(type='str', choices=ALL_COMMANDS),
            label=dict(type='str', default='red'),
            vmtype=dict(type='str', default='AppVM'),
            template=dict(type='str', default='default'),
            properties=dict(type='dict', default={}),
            tags=dict(type='list', default=[]),
        ),
    )

    if not HAS_QUBES:
        module.fail_json(msg='The `qubesos` module is not importable. Check the requirements.')

    rc = VIRT_SUCCESS
    try:
        rc, result = core(module)
    except Exception as e:
        module.fail_json(msg=to_native(e), exception=traceback.format_exc())

    if rc != 0:  # something went wrong emit the msg
        module.fail_json(rc=rc, msg=result)
    else:
        module.exit_json(**result)


if __name__ == '__main__':
    main()
