Ansible Role: Graylog Git-Sync
=========

This Ansible role will set up [Graylog](https://www.graylog.org/) using docker-compose.yml. **It is built for and only tested on Ubuntu 20.04.** It exposes the Graylog settings/database as Docker local volumes for easy back up.

Gmail is used as the SMTP provider for alerts. All you need is a Gmail account to get e-mail notifications. I highly encourage you to use an Application Specific Password so you do not have to keep your Gmail password in your playbook. Find out [how to set up an application password for Gmail](https://support.google.com/accounts/answer/185833?hl=en).

This role will also set up UFW rules that allows HTTPS access and allows Syslog/GELF traffic only from computers on your LAN/intranet.

This role was crafted using the following resources:

* [Official Graylog Docker instructions](https://docs.graylog.org/en/3.3/pages/installation/docker.html)
* [Community post on "Setting up email for alerts"](https://community.graylog.org/t/setting-up-email-for-alerts/6917)
* [Unofficial Graylog Dockerfile README](https://hub.docker.com/r/eeacms/graylog2)

### Notes on Setting Up a Reverse Proxy

If you would like to use one of your CloudFlare domain names for Graylog, then I recommend you check out my [NGINX Optimized role](https://galaxy.ansible.com/professormanhattan/ansible_nginx_optimized). This role will set up NGINX with ModSecurity and an automatic wildcard LetsEncrypt SSL certificate. This is done by passing the role a CloudFlare API key. You can even use the SSL certificate even if you do not want your FQDN to be internet-facing. You can achieve the effect by using a DNS server like PiHole and registering your FQDN to your local IP address of the Graylog instance. If you have a spare Raspberry Pi laying around, check out my [PiHole-CloudFlared role](https://galaxy.ansible.com/professormanhattan/ansible_pihole_cloudflared) which will set up the Raspberry Pi as a DNS-over-HTTPS PiHole for use as a private, local-intranet DNS server.

Additional resources:

* [Setting up an NGINX reverse proxy for Graylog](https://community.graylog.org/t/graylog-docker-container-behind-an-nginx-reverse-proxy-in-a-sub-directory/5264/3)

Requirements
------------

Both docker and docker-compose should be available. Additionally, this role relies on the docker command being available without sudo.

Role Variables
--------------

All of the variables in the Required Variables should be included in your playbook. There are additional details in the comments located in `defaults/main.yml`. If you would like to have the Graylog settings automatically sync with a git repository, then you should include the link to a fresh, empty repository under the `graylog_settings_git` variable name.

Dependencies
------------

None.

Example Playbook
----------------

```
- hosts: servers
  tasks:
    name: Install Graylog
    include_role:
      name: professormanhattan.ansible_graylog
    when: graylog_fqdn is defined
```

License
-------

MIT

Author Information
------------------

This role was created by [Brian Zalewski](https://github.com/ProfessorManhattan) as a [Megabyte LLC](https://megabyte.space) production.
