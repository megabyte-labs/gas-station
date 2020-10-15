Hyper-V
=========

Ansible role to interact with a Hyper-V server to power-off, delete, and
provision virtual machines.

Requirements
------------

- Ansible 2.9 or lower
- Library files from [ansible-hyperv](https://github.com/tsailiming/ansible-hyperv)

Role Variables
--------------

The following variables can be used for the role.

Role Variable | Required | Default | Description
------------- | -------- | ------- | ----------
hyperv_vm_name | yes | | Virtual machine name |
hyperv_vhdx_dest | yes | | Path of vm VHDX image |
hyperv_vm_cpu | no | 1 | CPUs allocated for vm |
hyperv_vm_memory | no | 1024 | Memory allocated for vm |
hyperv_vm_network_switch | yes | | Network switch for vm |
hyperv_vm_ip | yes | | IP address of vm |
hyperv_vm_netmask | yes | | Netmask of vm |
hyperv_vm_gateway | yes | | Gateway of vm |
hyperv_vm_dns | yes | | DNS for vm |
hyperv_vm_connection | no | winrm | Ansible connection to use for vm |
hyperv_vm_groups | no | | Inventory groups for vm |
hyperv_vm_ansible_port | no | 2214 | Ansible port to communicate with vm |

Example Playbook
----------------

With the role you can power-off, provision, or delete a vm. Once you have the playbook
you can pass the appropriate tag for the required action.

delete - Deletes the vm
provision - Provisions a new vm
poweroff - Power off a vm

```yml
---
- hosts: hyperv
  vars:
    hyperv_vm_name: windows10
    hyperv_vhdx_dest: "C:\Users\Public\Documents\Hyper-V\{{ hyperv_vm_name }}.vhdx"
    hyperv_vm_network_switch: WAN1
    hyperv_vm_ip: 192.168.100.10
    hyperv_vm_netmask: 255.255.255.0
    hyperv_vm_gateway: 192.168.100.1
    hyperv_vm_dns: 192.168.100.53

  roles:
    - role: hyperv
```

You can then run the playbook, and pass the required tag.

```console
ansible-playbook -t provision hyperv.yml
```

License
-------

[GPLv3](LICENSE)
