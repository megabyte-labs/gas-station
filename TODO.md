# TODOs

You are welcome to add your ideas to the TODO list. In fact, you are encouraged. This cannot become an awesome open source project unless you weigh in too!

## Playbook TODOs

- Test PiHole role
- Add useful functions to AutoKey/AutoHotkey
- Test AWX role
  - Implement with Docker if it possible
- Test role for FreeIPA
  - Set up initial users
  - Integrate LDAP with Authelia
- Add Keycloak role
  - Configure Keycloak to work with FreeIPA
- Run "brew install postgresql" before pip install pgcli on Darwin
- Switch to Docker secrets
  - Figure out if it is better to use HashiCorp Vault instead of Docker secrets
- Create configurations necessary for unattended installations
- Fix StatPing
- Symlink NextCloud to include all files
- Add Shellcheck to pre-commit
- Get Docker container that can do all pre-commit stuff
  - [shellcheck](https://github.com/koalaman/shellcheck)
  - [shfmt](https://github.com/mvdan/sh)
- Fix permissions in /usr/share/applications
- Run once for homebrew, snap
- Make unifi.home.megabyte.space accessible
- Fix docker-compose WireGuard tunnel issue
- Guacamole role
- IntelliJ role names IntelliJ IDEA as IntelliJ IDEA CE - should be named IntelliJ IDEA
- When installing TeamViewer on Mac OS X, a dialog pops up that asks "How do you want to use TeamViewer?".. should be automated

## pfSense TODOs

- Get Chromecast working on Ubuntu

## Megabyte Space TODOs

- WikiJS
- WordPress
- Strapi
- EasyEngine
- Create [Megabyte Space](https://megabyte.space)
  - Add Privacy Policy (/privacy)
  - Add Terms (/terms)
  - Add Support page (/support)

## Research Topics

- Terraform
- Thanos
- Kafka
- Synergy keyboard/mouse sharing
- NTP - Chrony or NTP?
- Logrotate
- [Teleport](https://github.com/gravitational/teleport)
- Rundeck (LDAP)
- SecurityOnion
- Kubernetes
- [Sentry](https://sentry.io/welcome/) on Kubernetes
- [Rancher](https://rancher.com/)
- Kubernetes
- Minio
- Home Assistant
- Resilio Sync
- nmap
- [watch](https://osxdaily.com/2010/08/22/install-watch-command-on-os-x/)

## Windows TODOs

- Look into IIS-WinidowsAuthentication optional feature
- Apply base-layout via group policy

## TODOs On Hold

- Ubuntu NetworkManager VPN plugin for WireGuard (currently compiling it from source)
- WireGuard for pfSense

## ERRORS

Wireshark already installed on Mac OS X:

```
TASK [roles/applications/wireshark : Include variables based on the operating system] **********************************************************
ok: [workstation]

TASK [roles/applications/wireshark : include_tasks] ********************************************************************************************
included: /Users/bzalewski/Playbooks/roles/applications/wireshark/tasks/install-Darwin.yml for workstation

TASK [roles/applications/wireshark : Ensure Wireshark is installed] ****************************************************************************
fatal: [workstation]: FAILED! => {"changed": false, "msg": "Error: It seems there is already a Binary at '/usr/local/bin/editcap'."}
[WARNING]: Failure using method (v2_runner_on_failed) in callback plugin
(<ansible_collections.community.general.plugins.callback.mail.CallbackModule object at 0x10f158bb0>): [Errno 61] Connection refused
```
