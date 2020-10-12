Role Name
=========

Install and configure the `ssh-server`.

Requirements
------------

- Ansible 2.9.10 or above
- `ansible.posix` collection

Role Variables
--------------

The following variables are used.

Role Variable | Required | Default | Description
------------- | -------- | ------- | ----------
ssh_ansible_user | no | ansible_user | Ansible user
ssh_private_keys | yes | | SSH private keys
authorized_key_file | yes | | SSH authorized key file
ssh_private_keys_root | yes | | SSH private keys for root user

Example Playbook
----------------

```yml
---
- hosts: ssh
  vars:
    ssh_ansible_user: "{{ ansible_user }}"
    ssh_private_keys:
      - id_rsa
      - id_rsa_local
      - id_rsa_web
    authorized_key_file: id_rsa_local.pub
    ssh_private_keys_root:
      - id_rsa
      - id_rsa_local
      - id_rsa_web

  roles:
    - role: ssh
```

License
-------

[GPLv3](LICENSE)
