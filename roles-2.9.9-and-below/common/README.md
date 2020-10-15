Role Name
=========

Ansible role for common actions

Requirements
------------

- Ansible 2.9.9 or lower

Role Variables
--------------

The following variables are used.

Role Variable | Required | Default | Description
------------- | -------- | ------- | ----------
common_ansible_user | no | ansible_user | Ansible user
common_snaps | no | snaps | defined snaps
common_homebrew_packages | no | homebrew_packages | homebrew packages
common_hostname | no | hostname | Defined hostname
common_software | no | software| Defined software

Example Playbook
----------------

```yml
---
- hosts: common
  vars:
    common_ansible_user: user

  roles:
    - role: apps
```

License
-------

[GPLv3](LICENSE)
