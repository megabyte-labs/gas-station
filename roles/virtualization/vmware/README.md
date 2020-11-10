ansible-role-vmware-workstation
=========

A role for installing VMware Workstation on Linux

Requirements
------------

Requires an internet connection to download the installer.  This can be downloaded separatly if desired.

Role Variables
--------------

* **workstation__license** is the license key to use when installing.

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: vmware.vmware-workstation, workstation_license: XXX-YYY-XXX }


## Contributing

The ansible-role-vmware-workstation project team welcomes contributions from the community. Before you start working with ansible-role-vmware-workstation, please read our [Developer Certificate of Origin](https://cla.vmware.com/dco). All contributions to this repository must be signed as described on that page. Your signature certifies that you wrote the patch or have the right to pass it on as an open-source patch. For more detailed information, refer to [CONTRIBUTING.md](CONTRIBUTING.md).

## License
Copyright © 2018 VMware, Inc. All Rights Reserved.
SPDX-License-Identifier: MIT OR GPL-3.0-only
