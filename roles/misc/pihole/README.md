Ansible Role: PiHole+Cloudflared
=========

**This playbook is intended to be used with a Raspberry Pi on Ubuntu 20.04.** It sets up PiHole, utilizing Cloudflared to send DNS queries upstream over HTTPS (encrypted DNS). It is meant to be an easy way of setting up Raspberry Pi with encrypted DNS.

It also disables Bluetooth/WiFi for power savings and adds the ability to set up the appropriate UFW rules. After the script runs, make sure you enable UFW after making sure other necessary ports are open like SSH for example.

Requirements
------------

A Rasberry Pi 4, preferrably

Role Variables
--------------

You should customize `pihole_admin_email` and `pihole_ipv4_address`. You can see the other variables that are used to customize `pihole-setupVars.conf` in `defaults/main.yml`.

Dependencies
------------

This repository is dependent on [Ansible Cloudflared](https://github.com/bendews/ansible-cloudflared). At the time of writing this, the Ansible Galaxy role is out of date (and not working with 32-bit Ubuntu Core) so the role is sourced from the GitHub page which is up to date.

Example Playbook
----------------

```
- hosts: raspberrypi
  tasks:
      - name: Install PiHole with encrypted DNS
        include_role:
        name: professormanhattan.ansible_pihole_cloudflared
```

License
-------

MIT

Author Information
------------------

This role was created by [Brian Zalewski](https://github.com/ProfessorManhattan) as a [Megabyte LLC](https://megabyte.space) production.

