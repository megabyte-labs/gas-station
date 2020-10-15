Ansible Role: MAAS
=========

Installs MAAS and does some of the standard tasks that follow an install. It will also add the necessary rules in UFW.

Requirements
------------

Ubuntu 20.04

Role Variables
--------------

Make sure to customize all the variables in `defaults/main.yml`.

```
maas_admin_email: name@example.com
maas_admin_password: password
maas_admin_username: admin
maas_database_host: localhost
maas_database_name: maas
maas_database_password: OverrideThisWithSomethingSecure
maas_database_username: Ella
```

Dependencies
------------

None

Example Playbook
----------------

```
- hosts: servers
  tasks:
    - name: Install MAAS
      include_role:
        name: professormanhattan.ansible_maas
```

License
-------

MIT

Author Information
------------------

This role was created by [Brian Zalewski](https://github.com/ProfessorManhattan) as a [Megabyte LLC](https://megabyte.space) production.
