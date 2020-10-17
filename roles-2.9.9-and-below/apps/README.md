Role Name
=========

Ansible role to install applications

Requirements
------------

- Ansible 2.9.9 or lower

Role Variables
--------------

The following variables are used.

Role Variable | Required | Default | Description
------------- | -------- | ------- | ----------
apps_ansible_user | no | ansible_user | The user for configurations

Example Playbook
----------------

```yml
---
- hosts: apps
  vars:
    apps_ansible_user: user

  roles:
    - role: apps
```

License
-------

[GPLv3](LICENSE)
