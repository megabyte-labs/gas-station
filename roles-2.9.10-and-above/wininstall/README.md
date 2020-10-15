Role Name
=========

Ansible role to install Windows software

Requirements
------------

- Ansible 2.10 or later
- `ansible.windows` collection
- `chocolatey.chocolatey` collection

Example Playbook
----------------

```yml
---
- hosts: servers
  collections:
    - ansible.windows
    - chocolatey.chocolatey
  tasks:
    roles:
      - role: wininstall
```

License
-------

[GPLv3](LICENSE)
