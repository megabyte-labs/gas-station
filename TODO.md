# TODOs

You are welcome to add your ideas to the TODO list. In fact, you are encouraged. This cannot become an awesome open source project unless you weigh in too!

## Playbook TODOs

- Test PiHole role
- Add static VPN routes so that the user can access the LAN while connected to a VPN
- Add useful functions to AutoKey/AutoHotkey
- Test AWX role
  - Implement with Docker if it possible
- Test role for FreeIPA
  - Set up initial users
  - Integrate LDAP with Authelia
- Add Keycloak role
  - Configure Keycloak to work with FreeIPA
- Add Resilio Sync role
- Make Docker role not require a system restart
- Add role that installs snapd on any Linux system
- Add obfuscation to docker-compose-backup
- Add SSH config for GitLab
- Create machine NGINX profile with the following apps:
  - Adminer
  - Cockpit
  - Duplicacy ([Theme](https://github.com/gilbN/theme.park/wiki/Duplicacy))
  - File Browser ([Theme](https://github.com/gilbN/theme.park))
  - Homer homepage
  - Netdata ([Theme](https://github.com/gilbN/theme.park/wiki/Netdata))
- Figure out if it is possible to install [Windows Admin Center](https://www.microsoft.com/en-us/windows-server/windows-admin-center) on Windows 10 Enterprise
- Switch to Docker secrets
  - Figure out if it is better to use HashiCorp Vault instead of Docker secrets
- Add Netdata as Docker service to Windows
- Create configurations necessary for unattended installations
- Fix StatPing
- Make HTPC Docker Compose use bundled WireGuard VPN
- Symlink NextCloud to include all files
- Module/plugin for determining what files were created/deleted
- Add Shellcheck to pre-commit
- Get Docker container that can do all pre-commit stuff
  - [shellcheck](https://github.com/koalaman/shellcheck)
  - [shfmt](https://github.com/mvdan/sh)
- Add commit message prompt for git master
- Figure out Node.js PATH problem
- FTP client

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
- NGINX Optimized Dockerized
- Kubernetes
- [Sentry](https://sentry.io/welcome/) on Kubernetes
- [Rancher](https://rancher.com/)
- Kubernetes
- Minio
- Home Assistant

## Windows TODOs

- Look into IIS-WinidowsAuthentication optional feature
- Apply base-layout via group policy

## TODOs On Hold

- Ubuntu NetworkManager VPN plugin for WireGuard (currently compiling it from source)
- WireGuard for pfSense
