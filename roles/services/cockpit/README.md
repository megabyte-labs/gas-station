<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme.md" ⚠️--><div align="center">
  <center>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/cockpit">
      <img width="140" height="140" alt="Cockpit logo" src="https://gitlab.com/megabyte-space/ansible-roles/cockpit/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center">Ansible Role: Cockpit</h1></center>
  <center><h4 style="color: #18c3d1;">An open-source Ansible role brought to you by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4></center>
</div>

<div align="center">
  <h4 align="center">
    <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/home-solid.svg" />
    </a>
    <a href="https://galaxy.ansible.com/professormanhattan/cockpit" title="Cockpit role on Ansible Galaxy" target="_blank">
      <img height="50" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/ansible-galaxy.svg" />
    </a>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/cockpit/-/blob/master/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/contributing-solid.svg" />
    </a>
    <a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/support-solid.svg" />
    </a>
    <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Slack chat room" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/chat-solid.svg" />
    </a>
    <a href="https://github.com/ProfessorManhattan/ansible-cockpit" title="GitHub mirror" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/github-solid.svg" />
    </a>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/cockpit" title="GitLab repository" target="_blank">
      <img src="https://gitlab.com/megabyte-labs/assets/-/raw/master/svg/gitlab-solid.svg" />
    </a>
  </h4>
  <p align="center">
    <a href="https://galaxy.ansible.com/professormanhattan/cockpit" target="_blank">
      <img alt="Ansible Galaxy role: professormanhattan.cockpit" src="https://img.shields.io/ansible/role/ansible_galaxy_project_id?logo=ansible&style=flat" />
    </a>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/cockpit" target="_blank">
      <img alt="Version: 1.0.0" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
    </a>
    <a href="https://github.com/ProfessorManhattan/ansible-cockpit/actions/Windows.yml" target="_blank">
      <img alt="Windows 10 build status" src="https://img.shields.io/github/workflow/status/ProfessorManhattan/ansible-cockpit/Windows/master?color=cyan&label=Windows%20build&logo=windows&style=flat">
    </a>
    <a href="https://github.com/ProfessorManhattan/ansible-cockpit/actions/macOS.yml" target="_blank">
      <img alt="macOS build status" src="https://img.shields.io/github/workflow/status/ProfessorManhattan/ansible-cockpit/macOS/master?label=macOS%20build&logo=apple&style=flat">
    </a>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/cockpit/commits/master" target="_blank">
      <img alt="Linux build status" src="https://gitlab.com/megabyte-space/ansible-roles/cockpit/badges/master/pipeline.svg">
    </a>
    <a href="https://galaxy.ansible.com/professormanhattan/cockpit" target="_blank" title="Ansible Galaxy quality score (out of 5)">
      <img alt="Ansible Galaxy quality score" src="https://img.shields.io/ansible/quality/ansible_galaxy_project_id?logo=ansible&style=flat" />
    </a>
    <a href="https://galaxy.ansible.com/professormanhattan/cockpit" target="_blank">
      <img alt="Ansible Galaxy downloads" src="https://img.shields.io/ansible/role/d/53381?logo=ansible&style=flat">
    </a>
    <a href="https://megabyte.space/docs/ansible" target="_blank">
      <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg?logo=readthedocs&style=flat" />
    </a>
    <a href="repository.gitlab_ansible_roles_group/cockpit/-/raw/master/LICENSE" target="_blank">
      <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-yellow.svg?style=flat" />
    </a>
    <a href="https://opencollective.com/megabytelabs" title="Support us on Open Collective" target="_blank">
      <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAElBMVEUAAACvzfmFsft4pfD////w+P9tuc5RAAAABHRSTlMAFBERkdVu1AAAAFxJREFUKM9jgAAXIGBAABYXMHBA4yNEXGBAAU2BMz4FIIYTNhtFgRjZPkagFAuyAhGgHAuKAlQBCBtZB4gzQALoDsN0Oobn0L2PEUCoQYgZyOjRQFiJA67IRrEbAJImNwFBySjCAAAAAElFTkSuQmCC&label=Open%20Collective%20sponsors&logo=opencollective&style=flat" />
    </a>
    <a href="https://github.com/ProfessorManhattan" title="Support us on GitHub" target="_blank">
      <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=flat" />
    </a>
    <a href="https://github.com/ProfessorManhattan" target="_blank">
      <img alt="GitHub: Megabyte Labs" src="https://img.shields.io/github/followers/ProfessorManhattan?style=social" target="_blank" />
    </a>
    <a href="https://twitter.com/MegabyteLabs" target="_blank">
      <img alt="Twitter: MegabyteLabs" src="https://img.shields.io/twitter/url/https/twitter.com/MegabyteLabs.svg?style=social&label=Follow%20%40MegabyteLabs" />
    </a>
  </p>
</div>

> </br><h3 align="center">**An Ansible role that installs Cockpit on Linux systems**</h3></br>

<!--TERMINALIZER![terminalizer_title](https://gitlab.com/megabyte-space/ansible-roles/cockpit/-/raw/master/.demo.gif)TERMINALIZER-->

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#one-line-install-method)

## ➤ One-Line Install Method

Looking to install Cockpit without having to deal with [Ansible](https://www.ansible.com/)? Simply run the following command that correlates to your operating system:

**Linux/macOS:**

```shell
curl -sS https://install.doctor/cockpit | bash
```

**Windows:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://win.install.doctor/cockpit'))
```

And there you go. Installing cockpit can be as easy as that. If, however, you would like to incorporate this into an Ansible playbook (and customize settings) then please continue reading below.

**Important Note:** _Before running the commands above you should probably directly access the URL to make sure the code is legit. We already know it is safe but, before running any script on your computer, you should inspect it._

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

- [➤ One-Line Install Method](#-one-line-install-method)
- [➤ Overview](#-overview)
- [➤ Supported Operating Systems](#-supported-operating-systems)
- [➤ Dependencies](#-dependencies)
  - [Galaxy Roles](#galaxy-roles)
- [➤ Example Playbook](#-example-playbook)
- [➤ Contributing](#-contributing)
- [➤ License](#-license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#overview)

## ➤ Overview

This repository is the home of an Ansible role that installs Cockpit on Linux systems. [Cockpit](https://cockpit-project.org/) allows you to view many aspects of system performance and make configuration changes, though the task list may depend on the particular flavor of Linux that you are using.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

The chart below shows the operating systems that we have tested this role on. It is automatically generated using the Ansible Molecule tests located in the `molecule/default/` folder. There is logic in place to automatically handle the testing of Windows, macOS, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it is possible that the role will still work.

| OS Family | OS Version | Status | Idempotent |
| --------- | ---------- | ------ | ---------- |
| Fedora    | 33         | ❌     | ❌         |
| Ubuntu    | focal      | ✅     | ❌         |

_The compatibility chart above was last generated on compatibility_date._

**_What does idempotent mean?_** Idempotent means that if you run this role twice in row then there will be no changes to the system the second time around.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#dependencies)

## ➤ Dependencies

Most of our roles rely on [Ansible Galaxy](https://galaxy.ansible.com/) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies, as well as the Python requirements, by running:

```
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

### Galaxy Roles

Although most of our roles do not have dependencies, there are some cases where another role has to be installed before the logic can continue. At the beginning of the play, the Ansible Galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles which help keep our [main playbook](https://gitlab.com/ProfessorManhattan/Playbooks) DRY.

The `requirements.yml` file contains a full list of the dependencies required by this role (i.e. `meta/main.yml` dependencies, helper roles, and collections). For your convenience, the full list of the dependencies along with quick descriptions is below:

role_dependencies

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#example-playbook)

## ➤ Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.cockpit
```

If you are incorporating this role into a pre-existing playbook, then it might be prudent to copy the requirements in `requirements.txt` and `requirements.yml` to their corresponding files in the root of your playbook.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/cockpit/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/cockpit/-/raw/master/CONTRIBUTING.md).

<details>
<summary>Sponsorship</summary>
<br/>
<blockquote>
<br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a href="https://www.patreon.com/ProfessorManhattan">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

</details>

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#license)

## ➤ License

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](repository.gitlab_ansible_roles_group/cockpit/-/raw/master/LICENSE) licensed.
