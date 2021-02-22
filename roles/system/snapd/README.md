# Ansible Role: Snap

<div align="center">
  <h4>
    <a href="{{ main_playbook_url }}">Main Playbook</a>
    <span> | </span>
    <a href="https://galaxy.ansible.com/professormanhattan/snapd">Galaxy</a>
    <span> | </span>
    <a href="https://contrib">Contributing</a>
    <span> | </span>
    <a href="{{ chat_url }}">Chat</a>
    <span> | </span>
    <a href="{{ homepage_url }}">Website</a>
  </h4>
</div>
<p style="text-align:center;">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://megabyte.space/wiki/snapd" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="https://gitlab.com/megabyte-space/ansible-roles/snapd/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

> Ansible role that installs everything you need to use snap on Linux distros

## Requirements

None.

#### Supported Operating Systems

The following chart shows the operating systems that have been tested as working. This role might still work for operating systems that are not listed.

| Operating System | Supported Versions      |
| ---------------- | ----------------------- |
| Ubuntu           | focal, thing, two, four |

## Role Variables

None.

## Dependencies

None.

## Example Playbook

All you have to do is add the role to your main playbook. The role handles the `become` behavior, so you can simply add the role to your playbook without worry:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.snapd
```

## Other Roles

This role is part of the main playbook. The playbook includes a bunch of other nifty roles that you may want to consider using. You can browse through the roles below:

| Role Name | Role Description        |
| --------- | ----------------------- |
| Ubuntu    | focal, thing, two, four |

## Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/snapd/-/issues). You can also take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/snapd/-/raw/master/CONTRIBUTING.md).

#### Show your support

Give a ⭐️ if this project helped you!

<a href="https://www.patreon.com/ProfessorManhattan">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

#### Contact

**Brian Zalewski** (ProfessorManhattan)

- Website: [Megabyte Labs Homepage](https://megabyte.space)
- Twitter: [@PrfssrManhattan](https://twitter.com/PrfssrManhattan)
- Github: [@ProfessorManhattan](https://github.com/ProfessorManhattan)
- LinkedIn: [@blzalewski](https://linkedin.com/in/blzalewski)

## License

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-space/ansible-roles/snapd/-/raw/master/LICENSE) licensed.
