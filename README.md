<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme-playbooks.md" ⚠️--><h1 align="center" style="text-align:center;">Ansible Role: Android Studio</h1>

<div align="center">
  <h4>
    <a href="https://gitlab.com/ProfessorManhattan/Playbooks">Main Playbook</a>
    <span> | </span>
    <a href="https://galaxy.ansible.com/professormanhattan/androidstudio">Galaxy</a>
    <span> | </span>
    <a href="https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/blob/master/CONTRIBUTING.md">Contributing</a>
    <span> | </span>
    <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/">Chat</a>
    <span> | </span>
    <a href="https://megabyte.space">Website</a>
  </h4>
</div>
<p style="text-align:center;">
  <a href="https://gitlab.com/megabyte-space/ansible-roles/androidstudio">
    <img alt="Version" src="https://img.shields.io/badge/version-0.0.1-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://megabyte.space/docs/androidstudio" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="repository.gitlab_ansible_roles_group/androidstudio/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/follow/PrfssrManhattan.svg?style=social" />
  </a>
</p>

This repository contains Ansible playbooks that provision both desktop development environments and servers. Almost all the roles included by this playbook are custom-made, cross-platform (i.e. Linux, Mac OS X, and Windows), and highly config-driven. All of the software included in this set of playbooks is the result of hours of researching what the best development software is (by comparing GitHub stars, "Top 10" blog articles, and looking through GitHub awesome lists). This set of playbooks is ideal for someone who uses several different operating systems or frequently switches between operating systems.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

* [➤ Quick Start](#-quick-start)
* [➤ Supported Operating Systems](#-supported-operating-systems)
* [➤ Dependencies](#-dependencies)
	* [Galaxy Roles](#galaxy-roles)
* [➤ Project Structure](#-project-structure)
* [➤ Managing Environments](#-managing-environments)
* [➤ Contributing](#-contributing)
* [➤ License](#-license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#quick-start)

## ➤ Quick Start

The easiest way to run the `main.yml` playbook is to run the following command on Linux or Mac OS X:

```shell
bash <(wget -qO- https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/quickstart.sh)
```

The above command will install the dependencies and run the `main.yml` playbook on a single machine. This is probably the best way to get your feet wet before you decide to give us a ⭐ and customize the playbook for your own needs. See the [Windows section](#windows) if you are looking to test this playbook out on Windows.


[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

The following chart shows the operating systems that have been tested for compatibility. This chart is automatically generated using the Ansible Molecule tests you can view in the `molecule/default/` folder. We currently have logic in place to automatically handle the testing of Archlinux, CentOS, Debian, Fedora, Ubuntu, and Windows. If your operating system is not listed but is a variant of one of the systems we test then it might still work.


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

 
| Role Dependency                                  | Description                                |
|--------------------------------------------------|--------------------------------------------|
| <a href='https://google.com'>professormanhattan.java</a> | Installs Java on nearly any OS             |
| <a href='https://bing.com'>professormanhattan.snapd</a> | Ensures Snap is installed on Linux systems |




[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#project-structure)

## ➤ Project Structure

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#managing-environments)

## ➤ Managing Environments

We accomplish managing different environments through symlinking. In the `environments/` folder, you will see multiple options. In our case, `environments/dev/` contains sensible configurations for testing the playbook and its' roles. The production environment is a seperate git submodule that links to a private git repository that contains our Ansible-vaulted API keys and passwords. When you are ready to set up your production configurations, we recommend you follow this method as well. 

There are two shell scripts in the root of this repository called `setup-dev.sh` and `setup-prod.sh`. Those scripts show an example of symlinking your environment files.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/CONTRIBUTING.md).

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

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](repository.gitlab_ansible_roles_group/androidstudio/-/raw/master/LICENSE) licensed.

