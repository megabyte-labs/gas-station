<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-role.md" ⚠️--><div align="center">
  <center>
    <a href="https://github.com/ProfessorManhattan/ansible-java">
      <img width="148" height="148" alt="Java logo" src="https://gitlab.com/megabyte-labs/ansible-roles/java/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center"><i></i>Java<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">Crafted by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/ansible-java/blob/master/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/ansible-java" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/ansible-roles/java" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>
<br/>
<div align="center">
  <a title="Ansible Galaxy role: professormanhattan.java" href="https://galaxy.ansible.com/professormanhattan/java" target="_blank">
    <img alt="Ansible Galaxy role: professormanhattan.java" src="https://img.shields.io/ansible/role/ansible_galaxy_project_id?logo=ansible&style=flat-square" />
  </a>
  <a title="Version: 1.0.1" href="https://github.com/ProfessorManhattan/ansible-java" target="_blank">
    <img alt="Version: 1.0.1" src="https://img.shields.io/badge/version-1.0.1-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAACNJREFUCNdjIACY//+BEp9hhM3hAzYQwoBIAqEDYQrCZLwAAGlFKxU1nF9cAAAAAElFTkSuQmCC&cacheSeconds=2592000&style=flat-square" />
  </a>
  <a title="GitLab build status" href="https://gitlab.com/megabyte-labs/ansible-roles/java/-/commits/master" target="_blank">
    <img alt="Build status" src="https://img.shields.io/gitlab/pipeline-status/megabyte-labs/ansible-roles/java?branch=master&label=build&logo=gitlab&style=flat-square">
  </a>
  <a title="Windows 11 test status on GitHub" href="https://github.com/ProfessorManhattan/ansible-java/actions/workflows/Windows.yml" target="_blank">
    <img alt="Windows 11 test status" src="https://img.shields.io/github/workflow/status/ProfessorManhattan/ansible-java/Windows%20Ansible%20Role%20Test/master?color=cyan&label=windows&logo=windows&style=flat-square">
  </a>
  <a title="macOS test status on GitLab" href="https://gitlab.com/megabyte-labs/ansible-roles/java/-/commits/master" target="_blank">
    <img alt="macOS test status" src="https://img.shields.io/gitlab/pipeline-status/megabyte-labs/ansible-roles/java?branch=test%2Fdarwin&label=osx&logo=apple&style=flat-square">
  </a>
  <a title="Linux Molecule test status on GitLab" href="https://gitlab.com/megabyte-labs/ansible-roles/java/-/commits/master" target="_blank">
    <img alt="Linux Molecule test status" src="https://img.shields.io/gitlab/pipeline-status/megabyte-labs/ansible-roles/java?branch=test%2Flinux&label=linux&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAElBMVEUAAAAwPEEuOEIxOzswPj7///91+pI+AAAABXRSTlMANRkNJejDPNcAAAB+SURBVCjPddHBDYAgDIXhGtMRHMG7S3hvTP79VxFIQVq1wOVLm7wU8QIJpSThC2wGwwJoPQFKRdiAAIhGsAykZNSZAOVNMx4BMjwtpySgr6CDJdB/MAdJwAvSiFoE5aABHUb0ch0WHNQq+KPAOgCgrbEnbjAHArjGz3jr3hpumrQpvwi66rkAAAAASUVORK5CYII=&style=flat-square">
  </a>
  <a title="Ansible Galaxy quality score (out of 5)" href="https://galaxy.ansible.com/professormanhattan/java" target="_blank">
    <img alt="Ansible Galaxy quality score" src="https://img.shields.io/ansible/quality/ansible_galaxy_project_id?logo=ansible&style=flat-square" />
  </a>
  <a title="Ansible Galaxy download count" href="https://galaxy.ansible.com/professormanhattan/java" target="_blank">
    <img alt="Ansible Galaxy download count" src="https://img.shields.io/ansible/role/d/ansible_galaxy_project_id?logo=ansible&label=downloads&style=flat-square">
  </a>
  <a title="Documentation" href="https://megabyte.space/docs/ansible" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg?logo=readthedocs&style=flat-square" />
  </a>
  <a title="License: MIT" href="https://github.com/ProfessorManhattan/ansible-java/blob/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-yellow.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHpJREFUCNdjYOD/wMDAUP+PgYHxhzwDA/MB5gMM7AwMDxj4GBgKGGQYGCyAEEgbMDDwAAWAwmk8958xpIOI5zKH2RmOyhxmZjguAiKmgIgtQOIYmFgCIp4AlaQ9OczGkJYCJEAGgI0CGwo2HmwR2Eqw5SBnNIAdBHYaAJb6KLM15W/CAAAAAElFTkSuQmCC&style=flat-square" />
  </a>
</div>

> </br><h4 align="center">**An Ansible role that installs Java on almost any platform**</h4></br>

<!--TERMINALIZE![terminalizer_title](https://gitlab.com/megabyte-labs/ansible-roles/java* **github**: /raw/master/.demo.gif
* **gitlab**: /-/raw/master/.demo.gif)TERMINALIZE-->

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Supported Operating Systems](#supported-operating-systems)
- [Dependencies](#dependencies)
  - [Python](#python)
  - [Galaxy Roles](#galaxy-roles)
  - [Galaxy Collections](#galaxy-collections)
- [Example Playbook](#example-playbook)
  - [Real World Example](#real-world-example)
- [Contributing](#contributing)
- [License](#license)

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

This repository is the home of an [Ansible](https://www.ansible.com/) role that installs Java on almost any platform. [Java](https://www.java.com/en/) is a class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible.

<a href="#features" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Features

**Ensures Java is installed:**

- Installs Java using Chocolatey on Windows
- Ensures the `JAVA_HOME` variable is set
- Installs Java on macOS, Linux, and Windows systems
- Ensures Java is added to the `PATH`

**Windows optimization:**

- Removes Java folder from the start menu on Windows

<a href="#quick-start" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Quick Start

Looking to install Java without having to deal with [Ansible](https://www.ansible.com/)? Simply run the following command that correlates to your operating system:

**Linux/macOS:**

```shell
curl -sS https://install.doctor/java | bash
```

**Windows:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/java?os=win'))
```

**Important Note:** _Before running the commands above you should probably directly access the URL to make sure the code is legit. We already know it is safe but, before running any script on your computer, you should inspect it._

You can also check out **[Install Doctor](https://install.doctor)**. It is an app we created that can install any Ansible role with a one-liner. It has some other nifty features too like the ability to install binaries on-the-fly without requiring a password. However, if you would like to incorporate this role into an Ansible playbook (and customize settings) then please continue reading below.

<a href="#supported-operating-systems" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Supported Operating Systems

The chart below shows the operating systems that we have tested this role on. It is automatically generated using the Ansible Molecule tests located in the `molecule/` folder. There is CI logic in place to automatically handle the testing of Windows, macOS, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it is possible that the role will still work.

| OS Family | OS Version | Status | Idempotent | Tested On |
| --------- | ---------- | ------ | ---------- | --------- |

**_What does idempotent mean?_** Idempotent means that if you run this role twice in row then there will be no changes to the system the second time around.

We spent a lot of time perfecting our CI configurations and build tools. If you are interested in learning more about how we perfected our process then you might find our [Ansible common files](https://gitlab.com/megabyte-labs/common/ansible) and [Ansible documentation](https://gitlab.com/megabyte-labs/documentation/ansible) repositories interesting. See the [CONTRIBUTING.md](docs/CONTRIBUTING.md) guide for more details.

<a href="#dependencies" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Dependencies

Most of our roles rely on [Ansible Galaxy](https://galaxy.ansible.com) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies, as well as the Python requirements, by running:

```yaml
if type poetry &> /dev/null; then poetry install --no-root; else pip3 install -r .config/assets/requirements.txt; fi
ansible-galaxy install -r requirements.yml
```

Alternatively, you can simply run `bash .config/scripts/start.sh` if you are new to Ansible and do not mind the development requirements also being installed. This is the easy way of making sure that everything works properly.

### Python

Although the only tool necessary to run this play on a standard machine is Ansible (a Python package), we include several other Python dependencies that are required for specialized use cases and development. The table below details these packages:

| Package                                                                                                                                        | Description                                                                                                                                                                   | Required                     |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| <b><a href="https://pypi.org/project/ansible/" title="ansible on pypi.org" target="_blank">ansible</a></b>                                     | A configuration management system that can remotely configure computers                                                                                                       | <div align="center">✔️</div> |
| <b><a href="https://pypi.org/project/docker/" title="docker on pypi.org" target="_blank">docker</a></b>                                        | Enables the capability of provisioning Docker containers with Ansible                                                                                                         | <div align="center">✔️</div> |
| <b><a href="https://pypi.org/project/python-vagrant/" title="python-vagrant on pypi.org" target="_blank">python-vagrant</a></b>                | Required for provisioning Vagrant VMs                                                                                                                                         | <div align="center">✔️</div> |
| <b><a href="https://pypi.org/project/pywinrm/" title="pywinrm on pypi.org" target="_blank">pywinrm</a></b>                                     | Required for provisioning Windows machines that are using WinRM                                                                                                               | <div align="center">✔️</div> |
| <b><a href="https://pypi.org/project/ansible-lint/" title="ansible-lint on pypi.org" target="_blank">ansible-lint</a></b>                      | Linting tool for Ansible files                                                                                                                                                |                              |
| <b><a href="https://pypi.org/project/ansibler/" title="ansibler on pypi.org" target="_blank">ansibler</a></b>                                  | Custom tool used to generate advanced documentation (e.g. it generates the compatibility chart and some other charts)                                                         |                              |
| <b><a href="https://pypi.org/project/black/" title="black on pypi.org" target="_blank">black</a></b>                                           | Python file auto-formatter included in case project utilizes Python test scripts                                                                                              |                              |
| <b><a href="https://pypi.org/project/blocklint/" title="blocklint on pypi.org" target="_blank">blocklint</a></b>                               | Linting tool that prevents certain words from entering the code base                                                                                                          |                              |
| <b><a href="https://pypi.org/project/flake8/" title="flake8 on pypi.org" target="_blank">flake8</a></b>                                        | Python linter that reports Python syntax and style errors                                                                                                                     |                              |
| <b><a href="https://pypi.org/project/mod-ansible-autodoc/" title="mod-ansible-autodoc on pypi.org" target="_blank">mod-ansible-autodoc</a></b> | Custom fork of [ansible-autodoc](https://pypi.org/project/ansible-autodoc/0.5.1.1/) which allows us to auto-generate documentation based on comments in the role's YAML files |                              |
| <b><a href="https://pypi.org/project/molecule/" title="molecule on pypi.org" target="_blank">molecule</a></b>                                  | Test framework for Ansible                                                                                                                                                    |                              |
| <b><a href="https://pypi.org/project/molecule-docker/" title="molecule-docker on pypi.org" target="_blank">molecule-docker</a></b>             | Molecule plugin for provisioning Docker containers                                                                                                                            |                              |
| <b><a href="https://pypi.org/project/molecule-vagrant/" title="molecule-vagrant on pypi.org" target="_blank">molecule-vagrant</a></b>          | Molecule plugin for provisioning Vagrant VMs                                                                                                                                  |                              |
| <b><a href="https://pypi.org/project/pre-commit-hooks/" title="pre-commit-hooks on pypi.org" target="_blank">pre-commit-hooks</a></b>          | Suite of tools useful for linting                                                                                                                                             |                              |
| <b><a href="https://pypi.org/project/proselint/" title="proselint on pypi.org" target="_blank">proselint</a></b>                               | Linter used to generate English-language improvements (used to improve documentation)                                                                                         |                              |
| <b><a href="https://pypi.org/project/yamllint/" title="yamllint on pypi.org" target="_blank">yamllint</a></b>                                  | Linter for YAML files that ensures proper syntax and styling is used                                                                                                          |                              |

### Galaxy Roles

Although most of our roles do not have dependencies, there are some cases where another role has to be installed before the logic can continue. At the beginning of the play, the Ansible Galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles directly from the task files which helps keep our [main playbook (Gas Station)](repository.playbooks) DRY.

The `requirements.yml` file contains a full list of the Ansible Galaxy dependencies required by this role (i.e. `meta/main.yml` role dependencies, helper roles, collections, etc.). For your convenience, a list of the role dependencies along with quick descriptions is below:

role_dependencies

### Galaxy Collections

This role is dependent on multiple Ansible Galaxy collections. The collections along with a links to their source are listed below.

- <a href="https://galaxy.ansible.com/chocolatey/chocolatey" title="chocolatey.chocolatey collection on Ansible Galaxy" target="_blank"><img alt="chocolatey.chocolatey Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-chocolatey.chocolatey-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>
- <a href="https://galaxy.ansible.com/community/general" title="community.general collection on Ansible Galaxy" target="_blank"><img alt="community.general Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-community.general-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>

<a href="#example-playbook" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.java
```

If you are incorporating this role into a pre-existing playbook, then it might be prudent to copy the requirements outlined in `pyproject.toml` and `requirements.yml` to their corresponding files in the root of your playbook so you only have to worry about installing one set of requirements during future use. Note that the dependencies in `pyproject.toml` can be moved to the more traditional `requirements.txt`, if that is what you are currently using to track Python dependencies.

### Real World Example

You can find an example of a playbook that incorporates this role in our main playbook (a.k.a. [Gas Station](https://github.com/ProfessorManhattan/Gas-Station)). The playbook is an excellent example for someone learning how to use Ansible. It also incorporates a lot of well-thought out build tools that more advanced Ansible users can appreciate. And people who could care less about Ansible can also benefit from it because it allows you to more or less turn your computer (and network) into the ultimate development enivornment. The bottom line is that it is an awesome project that developers should know about!

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/ProfessorManhattan/ansible-java/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/ProfessorManhattan/ansible-java/blob/master/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Awesome Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
  <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
</a>
<a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
  <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
</a>
<a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
  <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright © 2020-2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/ansible-roles/java/-/blob/master/LICENSE) licensed.
