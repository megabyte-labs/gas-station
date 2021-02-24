<h1 align="center">Ansible Role: Android Studio</h1>
<div align="center">
  <h4>
    <a href="https://ecosystem">Main Playbook</a>
    <span> | </span>
    <a href="https://galaxy">Galaxy</a>
    <span> | </span>
    <a href="https://contrib">Contributing</a>
    <span> | </span>
    <a href="https://chat">Chat</a>
    <span> | </span>
    <a href="https://megabyte.space">Website</a>
  </h4>
</div>
<p style="text-align:center;">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="https://docs.megabyte.space/androidstudio" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

> Ansible role that installs Android Studio on nearly any OS

# Requirements

None.

## Supported Operating Systems

The following chart shows the operating systems that have been tested as working. This role might still work for operating systems that are not listed.

| Operating System | Supported Versions      |
| ---------------- | ----------------------- |
| Ubuntu           | focal, thing, two, four |

## Role Variables

None.

## Dependencies

This playbook requires snap to be installed on Linux distributions. Java is also included as a dependency.

By default, the following roles will install at the beginning of the play:

- [professormanhattan.java](https://gitlab.com/megabyte-space/ansible-roles/java) - Installs and configures Java
- [professormanhattan.snapd](https://gitlab.com/megabyte-space/ansible-roles/snapd) - Installs snap on Linux distributions

If you are handling the installation of these dependencies with another role, you can bypass the installation of these dependencies by setting the `install_role_dependencies` variable to `false`.

## Example Playbook

Start by installing the dependencies by executing the following command in the root of the role folder:

```
ansible-galaxy install -r requirements.yml
```

With the requirements installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior, so you can simply add the role to your playbook without worry:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.androidstudio
```

## Other Roles

This role is part of the main playbook. The playbook includes a bunch of other nifty roles that you may want to consider using. You can browse through the roles below:

| Role Name | Role Description        |
| --------- | ----------------------- |
| Ubuntu    | focal, thing, two, four |

## Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/issues). You can also take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/CONTRIBUTING.md).

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

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/LICENSE) licensed.
