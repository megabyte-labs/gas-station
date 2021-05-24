<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme-playbooks.md" ⚠️--><h1>ProfessorManhattan's Cross-Platform Playbook</h1>

<h4>
  <a href="https://megabyte.space">Homepage</a>
  <span> | </span>
  <a href="https://galaxy.ansible.com/professormanhattan">Galaxy Profile</a>
  <span> | </span>
  <a href="https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/CONTRIBUTING.md">Contributing</a>
  <span> | </span>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/">Chat</a>
  <span> | </span>
  <a href="https://megabyte.space/docs/ansible">Documentation</a>
</h4>
<p>
  <a href="https://gitlab.com/ProfessorManhattan/Playbooks">
    <img alt="Version" src="https://img.shields.io/badge/version-version-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://megabyte.space/docs/ansible" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/MegabyteLabs" target="_blank">
    <img alt="Twitter: MegabyteLabs" src="https://img.shields.io/twitter/follow/MegabyteLabs.svg?style=social" />
  </a>
</p>

> <br/>**An Ansible playbook you can use to set up the ultimate home lab!**<br/><br/>

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

- [➤ Introduction](#-introduction)
- [➤ Quick Start](#-quick-start)
  _ [Mac OS X/Linux](#mac-os-xlinux)
  _ [Windows](#windows)
- [➤ Supported Operating Systems](#-supported-operating-systems)
- [➤ Requirements](#-requirements)
  - [Optional Requirements](#optional-requirements)
  - [MAS on Mac OS X](#mas-on-mac-os-x)
- [➤ Roles](#-roles)
- [➤ Philosophy](#-philosophy)
- [➤ Architecture](#-architecture)
- [➤ Managing Environments](#-managing-environments)
- [➤ Contributing](#-contributing)
- [➤ License](#-license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#introduction)

## ➤ Introduction

This repository is home a collection of Ansible playbooks meant to provision computers and networks with the "best of GitHub". Using Ansible, you can provision your whole network relatively fast in the event of a disaster. This project is also intended to increase the security of your network by allowing you to frequently wipe, reinstall, and re-provision your network, bringing it back to its original state. This is done by backing up only what needs to be backed up (like database files and Docker volumes) to encrypted S3 buckets or git repositories. Each piece of software is included as an Ansible role. Sometimes there are multiple tools that exist that perform the same task. In these cases, extensive research is done to ensure that only the best, most-popular software makes it into our role collection.

This Ansible playbook is:

- Highly configurable (most roles come with optional variables that you can configure to change the behavior of the role)
- Compatible with all major operating systems (i.e. Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and even Archlinux)
- The product of a team of experts
- An amazing way to learn about developer tools that many would consider to be "the best of GitHub"
- Open to new ideas - feel free to [open an issue](https://gitlab.com/ProfessorManhattan/Playbooks/-/issues/new) or [contribute](https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/CONTRIBUTING.md) with a pull request!

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#quick-start)

## ➤ Quick Start

The easiest way to run the entire playbook, outlined in the `main.yml` file, is to run the appropriate command listed below. These commands will run the playbook on the machine you run the command on. This is probably the best way to get your feet wet before you decide to give us a ⭐ and customize the playbook for your own needs. Ideally, this command should be run on the machine that you plan on running Ansible with to provision the other computers on your network.

#### Mac OS X/Linux

```shell
bash <(wget -qO- https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/quickstart.sh)
```

#### Windows

```powershell

```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

The following chart shows the operating systems that have been tested for compatibility using the `environments/dev/` environment. This chart is automatically generated using the Ansible Molecule tests you can view in the `molecule/default/` folder. We currently have logic in place to automatically handle the testing of Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it might still work.

| OS Family | OS Version | Status | Idempotent |
| --------- | ---------- | ------ | ---------- |
| Fedora    | 33         | ❌     | ❌         |
| Ubuntu    | focal      | ✅     | ❌         |

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#requirements)

## ➤ Requirements

- **[Python 3](https://www.python.org/)**
- **[Ansible >2.9](https://www.ansible.com/)**

There are also several other Python and Ansible requirements that can be installed by running the following command in the root of this repository:

```
pip3 install -r requirements.txt
ansible-galaxy install requirements.yml
```

The method above should be used if you are not using the method detailed in the [Quick Start](#quick-start) section.

SSH (or WinRM in the case of Windows) and Python should be available on the target systems you would like to provision.

### Optional Requirements

**This playbook is built and tested to run on fresh installs of Windows, Mac OS X, Ubuntu, Fedora, Debian, CentOS, and Archlinux**. It may still be possible to run the playbook on your current machine. However, installing the playbook on a fresh install is the only thing we actively support. That said, if you come across an issue with an environment that already has configurations and software present, please do not hesitate to open an issue.

### MAS on Mac OS X

We use [mas](https://github.com/mas-cli/mas) to install apps from the App Store in some of our roles. Sadly, automatically signing into the App Store is not possible on OS X 10.13+ via mas. This is because [mas no longer supports login functionality on OS X 10.13+](https://github.com/mas-cli/mas/issues/164).

There is another caveat with mas. In order to install an application using mas, the application has to have already been added via the App Store GUI. This means that the first time around you will have to install the apps via the App Store GUI so they are associated with your App Store account.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#roles)

## ➤ Roles

This project breaks down every piece of software into a role (found in the subdirectories of the `roles/` folder). Below is a quick description of what each role does. Browsing through this list, along with the conditions laid out in `main.yml`, you will be able to get a better picture of what software will be installed by the default `main.yml` playbook.

role_descriptions

We encourage you to browse through the repositories that are linked to in the table above to learn about the configuration options they support.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#philosophy)

## ➤ Philosophy

The philosophy of this project basically boils down to "**_automate everything_**" and include the best development tools that might be useful without over-bloating the machine with services. Automating everything should include tasks like automatically accepting software terms in advance or pre-populating Portainer with certificates of all the Docker hosts you would like to control. One problem we face is that there are so many great tools offered on GitHub. A lot of research has to go into what to include and what to pass on. The decision of whether or not to include a piece of software in the default playbook basically boils down to:

- **Project popularity** - If one project has 10k stars and another one has 500 stars then 9 times of out 10 the more popular project is selected.
- **Last commit date** - We prefer software that is being actively maintained, for obvious reasons.
- **Cross platform** - Our playbook supports the majority of popular operating systems so we opt for cross-platform software. However, in rare cases, we will include software that has limited cross-platform support like Xcode (which is only for Mac OS X).
- **Usefulness** - If a tool could potentially improve developer effectiveness then we are more likely to include it.
- **System Impact** - Software that can be run with a small RAM footprint and software that does not need a service to load on boot is much more likely to be included.

One of the goals of this project is to be able to re-provision a network with the click of a button. This might not be feasible since consumer-grade hardware usually does not include features like LPMI (which is a feature included in high-end motherboards that lets you control the power state remotely). However, we aim to reduce the amount of interaction required when re-provisioning an entire network down to the bare minimum. In the worst case scenario, you will have to reformat, reinstall the operating system, and ensure that OpenSSH is running (or WinRM in the case of Windows). However, in the best case scenario, you will be able to reformat and reinstall the operating system used as your Ansible host using an automated USB installer and then automatically re-provision everything else on the network by utilizing LPMI.

You might ask, "But how can I retain application-level configurations?" We currently handle this by:

- Pre-defining dotfiles in a customizable Git repository
- Optionally, mounting Docker volumes to encrypted FUSE-based S3 file system mounts (which is only feasible with fast internet connections)
- Syncing files to private git repositories

However, we intentionally keep this synchronization to a minimum. After all, one of the goals of this project is to be able to regularly flush the bad stuff off a system. By keeping it to a minimum, we reduce the attack surface.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#architecture)

## ➤ Architecture

You can find a high-level overview of what each folder and file does in the [ARCHITECTURE.md](https://gitlab.com/ProfessorManhattan/Playbooks/-/blob/master/ARCHITECTURE.md) file.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#managing-environments)

## ➤ Managing Environments

We accomplish managing different environments by symlinking all the folders that should be unique to each network environment (e.g. `host_vars/`, `group_vars/`, `inventories/`, `files/vpn/`, and `files/ssh/`). In the `environments/` folder, you will see multiple folders. In our case, `environments/dev/` contains sensible configurations for testing the playbook and its' roles. The production environment is a seperate git submodule that links to a private git repository that contains our Ansible-vaulted API keys and passwords. When you are ready to set up your production configurations, you can use this method as well. But if you are just starting off, you do not have to worry about this since, by default, this playbook is configured to run with the settings included in the `/environments/dev/` folder.

As a convienience feature, we created a bash script that will set up all the symlinks for you. You can run this by running `bash environments/dev/link.sh`. This command will symlink all the folders in selected environment to their appropriate locations in the base project. If you create a new environment, you will have to add a symlink to the `link.sh` file found in `files/link.sh` to retain this feature.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/ProfessorManhattan/Playbooks/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/CONTRIBUTING.md).

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

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](repository.gitlab_ansible_roles_group/playr/-/raw/master/LICENSE) licensed.
