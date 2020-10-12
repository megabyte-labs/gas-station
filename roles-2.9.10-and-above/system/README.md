Role Name
=========

Ansible role to configure the system

Requirements
------------

- Ansible 2.10 or higher
- `ansible.posix` collection

Example Playbook
----------------

```yml
---
- hosts: servers
  collections:
    - ansible.posix
  tasks:
  roles:
    - role: system
```

License
-------

[GPLv3](LICENSE)
