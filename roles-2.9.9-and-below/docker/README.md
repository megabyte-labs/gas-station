Role Name
=========

Ansible role to install Docker

Requirements
------------

- Ansible 2.9.9 or lower
- Anisble role `geerlingguy.docker`

Example Playbook
----------------

```yml
---
- hosts: docker

  roles:
    - role: geerlingguy.docker
    - role: docker
```

License
-------

[GPLv3](LICENSE)
