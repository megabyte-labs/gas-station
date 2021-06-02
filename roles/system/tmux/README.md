<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme.md" ⚠️--><h1 align="center" style="text-align:center;">Ansible Role: tmux</h1>

<div align="center">
  <h4>
    <a href="https://gitlab.com/ProfessorManhattan/Playbooks">Main Playbook</a>
    <span> | </span>
    <a href="https://galaxy.ansible.com/professormanhattan/tmux">Galaxy</a>
    <span> | </span>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/tmux/-/blob/master/CONTRIBUTING.md">Contributing</a>
    <span> | </span>
    <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/">Chat</a>
    <span> | </span>
    <a href="https://megabyte.space">Website</a>
  </h4>
</div>
<p style="text-align:center;">
  <a href="https://gitlab.com/megabyte-space/ansible-roles/tmux">
    <img alt="Version" src="https://img.shields.io/badge/version-0.0.1-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://megabyte.space/docs/tmux" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="repository.gitlab_ansible_roles_group/tmux/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

<p align="center" style="text-align:center;">
  <b>An Ansible role that installs tmux on nearly any platform</b></br>
</p>


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

* [➤ Overview](#-overview)
* [➤ Supported Operating Systems](#-supported-operating-systems)
* [➤ Dependencies](#-dependencies)
  * [Galaxy Roles](#galaxy-roles)
* [➤ Example Playbook](#-example-playbook)
* [➤ Contributing](#-contributing)
* [➤ License](#-license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#overview)

## ➤ Overview

This repository contains an Ansible role that installs tmux on nearly any platform. The purpose of tmux is to get your music collection right once and for all. It catalogs your collection, automatically improving its metadata as it goes using the MusicBrainz database. Then it provides a bouquet of tools for manipulating and accessing your music.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

The following chart shows the operating systems that have been tested for compatibility. tmux is a terminal multiplexer: it enables a number of terminals to be created, accessed, and controlled from a single screen. tmux may be detached from a screen and continue running in the background, then later reattached


| OS Family | OS Version | Status | Idempotent |
|-----------|------------|--------|------------|
| Fedora    | 33         | ❌      | ❌          |
| Ubuntu    | focal      | ✅      | ❌          |



[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#dependencies)

## ➤ Dependencies

Most of our roles rely on [Ansible Galaxy](https://galaxy.ansible.com/) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies by running:

```
ansible-galaxy install -r requirements.yml
```

### Galaxy Roles

At the beginning of the play, the galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles which help keep our [main playbook](https://gitlab.com/ProfessorManhattan/Playbooks) DRY. A full list of the dependencies along with quick descriptions is below:

 role_dependencies



[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#example-playbook)

## ➤ Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.tmux
```


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/tmux/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/tmux/-/raw/master/CONTRIBUTING.md).

<details>
<summary>Sponsorship</summary>
<br/>
<blockquote>
<br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

***Brian Zalewski***<br/><br/>
</blockquote>

<a href="profile.patreon">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

</details>


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#license)

## ➤ License

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](repository.gitlab_ansible_roles_group/tmux/-/raw/master/LICENSE) licensed.

