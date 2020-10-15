Role Name
=========

Ansible role to install Windows software

Requirements
------------

- Ansible 2.9.9 or lower

Example Playbook
----------------

```yml
---
- hosts: servers
  tasks:
    roles:
      - role: wininstall
```

License
-------

[GPLv3](LICENSE)
