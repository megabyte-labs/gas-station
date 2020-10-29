Role Name
=========

Install and configure UFW

Requirements
------------

- Ansible 2.9.9 or lower

Role Variables
--------------

The following variables are used.

Role Variable | Required | Default | Description
------------- | -------- | ------- | ----------
security_ssh_port | yes | 2214 | ssh port
lan_network | yes | | lan networks
lab_ip_address | yes | 10.14.24.14 | Lab IP Address

Example Playbook
----------------

```yml
---
- hosts: servers
  vars:
    security_ssh_port: "2214"
    lan_network:
      auxilary: 10.14.67.0/24
      guest: 10.14.141.0/24
      iot: 10.14.33.0/24
      kubernetes: 10.14.24.0/24
      management: 10.0.0.0/24
      offline: 10.14.144.0/24
      unifi: 10.14.49.0/24
      work: 10.14.14.0/24
    lab_ip_address: 10.14.24.14

  tasks:
    roles:
      - role: ufw
```

License
-------

[GPLv3](LICENSE)
