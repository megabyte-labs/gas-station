Role Name
=========

Ansible role to configure Windows system

Requirements
------------

- Ansible 2.10 or later
- `ansible.windows` collection

Example Playbook
----------------

```yml
---
- hosts: servers
  collections:
    - ansible.windows
  tasks:
    roles:
      - role: winconfig
```

License
-------

[GPLv3](LICENSE)
