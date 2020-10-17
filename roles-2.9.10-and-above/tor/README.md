Role Name
=========

Ansible to configure a system for Tor

Requirements
------------

- Ansible 2.10 or higher

Example Playbook
----------------

```yml
---
- hosts: servers
  tasks:
    roles:
      - role: tor
```

License
-------

[GPLv3](LICENSE)
