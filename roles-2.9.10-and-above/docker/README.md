Role Name
=========

Ansible role to install Docker

Requirements
------------

- Ansible 2.9.10 or higher
- Anisble role `geerlingguy.docker`

Example Playbook
----------------

```yml
---
- hosts: docker

  roles:
    - role: geerlingguy.docker
    - role: apps
```

License
-------

[GPLv3](LICENSE)
