# QubesOS Task List

## Articles to Comb

* [GNOME in dom0](https://gist.github.com/code3z/244ea17d306f11fdf1127c8d4ce5296c)
* [Setting up network printer](https://github.com/Qubes-Community/Contents/blob/master/docs/configuration/network-printer.md#steps-to-configure-a-network-printer-in-a-template-vm)
* [VM hardening](https://github.com/tasket/Qubes-VM-hardening/)
* [Docker on Qubes](https://gist.github.com/xahare/6b47526354a92f290aecd17e12108353)
* [Misc. scripts including VagrantUp HVMs](https://github.com/unman/stuff)
* [U2F to specific sites](https://www.qubes-os.org/doc/u2f-proxy/)

## Roles to Re-Visit

```
- roles/applications/peek
- roles/system/ssh
- roles/services/sshtarpit
- roles/services/cups
- roles/services/cockpit
- roles/services/cloudflare
- roles/services/nginx
- roles/services/gitlabrunner
- roles/services/samba
- roles/services/tor
- roles/services/googleassistant
- roles/applications/sharex
- roles/applications/autokey
- roles/system/rear
- roles/system/timeshift
- roles/system/ulauncher
```

## Variables Needed for Qubes

```
hostctl_setup: false # Allows switching /etc/hosts profiles
hostsfile_default_loopback: false
install_switchhosts: false
```
