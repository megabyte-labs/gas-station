<!-- ⚠️ This README has been generated from the file(s) "./modules/docs/blueprint-contributing.md" ⚠️-->
[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

# ➤ Contributing

First of all, thanks for visiting this page 😊❤️! We are totally ecstatic that you may be considering contributing to this project. You should read this guide if you are considering creating a pull request.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

* [➤ Contributing](#-contributing)
	* [➤ Code of Conduct](#-code-of-conduct)
	* [➤ Philosophy](#-philosophy)
	* [➤ Supported Operating Systems](#-supported-operating-systems)
		* [Other Operating Systems](#other-operating-systems)
		* [Styling for Platform-Specific Roles](#styling-for-platform-specific-roles)
* [➤ tasks/main.yml in the Visual Studio role](#-tasksmainyml-in-the-visual-studio-role)
	* [➤ Setting Up Development Environment](#-setting-up-development-environment)
		* [Requirements](#requirements)
		* [Dependencies](#dependencies)
	* [➤ Pull Requests](#-pull-requests)
	* [➤ Code Style](#-code-style)
		* [Arrays](#arrays)
		* [Alphabetical Order](#alphabetical-order)
		* [main.yml](#mainyml)
		* [Dependency Variables](#dependency-variables)
		* [DRY](#dry)
	* [➤ Testing](#-testing)
		* [Idempotence](#idempotence)
		* [Debugging](#debugging)
		* [Molecule Documentation](#molecule-documentation)
		* [Testing Desktop Environments](#testing-desktop-environments)
	* [➤ Linting](#-linting)
		* [ansible-lint](#ansible-lint)
			* [[208] File permissions unset or incorrect](#208-file-permissions-unset-or-incorrect)
			* [[301] Command should not change things if nothing needs doing](#301-command-should-not-change-things-if-nothing-needs-doing)
			* [[305] Use shell only when shell functionality is required](#305-use-shell-only-when-shell-functionality-is-required)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#code-of-conduct)

## ➤ Code of Conduct

This project and everyone participating in it is governed by the [Atom Code of Conduct](https://github.com/atom/atom/blob/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [help@megabyte.space](mailto:help@megabyte.space).

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#philosophy)

## ➤ Philosophy

When you are working with a role, try asking yourself, "How can this be improved?" For example, in the case of the Android Studio role, maybe the role installs Android Studio but there may be additional tasks that should be automated. Consider the following examples:

* **The software is installed but is asking for a license key.** - In this case, we should ensure the role has an option for automatically installing the license key from a CLI command.
* **The software supports plugins** - We should provide an option for specifying the plugins that can be automatically installed.
* **In the case of Android Studio, many users have to install SDKs before using the software.** - We should offer the capability to automatically install user-specified SDKs.
* **The software has configuration files with commonly tweaked settings.** - We should provide the ability to change these settings from the playbook.
* **The software has the capability to integrate with another piece of software in the [main playbook](https://gitlab.com/ProfessorManhattan/Playbooks)**. - This integration should be automated.

Ideally, you should use the software that the role installs. This is really the only way of testing whether or not it was installed properly and has all the common settings automated. The software installed by the [main playbook](https://gitlab.com/ProfessorManhattan/Playbooks) is all widely-acclaimed, cross-platform software (for the most part) that many people find useful.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

All of our roles should run without error on the following operating systems:

* Archlinux (Latest)
* CentOS 7 and 8
* Debian 9 and 10
* Fedora (Latest)
* Ubuntu (16.04, 18.04, 20.04, and Latest)
* Mac OS X (Latest)
* Windows 10 (Latest)

### Other Operating Systems

We are considering adding support for the following operating systems. At your convienience, please also test the roles on:

* **Qubes**
* Elementary OS
* Zorin
* OpenSUSE
* Manjaro
* FreeBSD
* Mint

### Styling for Platform-Specific Roles

If you have a role that only installs software made for Windows 10 then ensure that the tasks are only run when the system is a Windows system by using `when:` in the `tasks/main.yml` file. For example, the following `main.yml` does this:

```yaml

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#tasksmainyml-in-the-visual-studio-role)

# ➤ tasks/main.yml in the Visual Studio role
---
- name: Include variables based on the operating system
  include_vars: "ansible_os_family.yml"
  when: ansible_os_family == 'Windows'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: "install-ansible_os_family.yml"
  when: ansible_os_family == 'Windows'
```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#setting-up-development-environment)

## ➤ Setting Up Development Environment

Before contributing to this project, you will have to make sure you have the tools that are utilized. The following is required for developing and testing this Ansible role:

### Requirements

* **Ansible** >=2.10
* **Python 3**, along with the `python3-netaddr` and `python3-pip` libraries (i.e. `sudo apt-get install python3 python3-netaddr python3-pip`)
* **Docker** - Used for running the Docker tests (this is not fully working, see [this issue](https://gitlab.com/ProfessorManhattan/Playbooks/-/issues/183))
* **VirtualBox** - Used for running the molecule tests

### Dependencies

With all the requirements installed, navigate to the root directory and run the following commands to install the Python dependencies and Ansible Galaxy dependencies:

```terminal
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
pre-commit install
git submodule update --init --recursive
```

If you are experiencing issues with the Python modules, you can make use of `venv` by running the following before running the above commands:

```terminal
python3 -m venv venv
source venv/bin/activate
```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#pull-requests)

## ➤ Pull Requests

All pull requests should be associated with issues. You can find the [issues board on GitLab](https://gitlab.com/ProfessorManhattan/Playbooks). The pull requests should be made to [the GitLab repository](https://gitlab.com/megabyte-space/ansible-roles/androidstudio) instead of the [GitHub repository](https://github.com/ProfessorManhattan/ansible-androidstudio). This is because we use GitLab as our primary repository and mirror the changes to GitHub for the community.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#code-style)

## ➤ Code Style

We try to follow the same code style across all our Ansible repositories. If something is done one way somewhere, then it should be done the same way elsewhere. It is up to you to [browse through our roles](https://gitlab.com/ProfessorManhattan/Playbooks/-/tree/master/roles) to get a feel for how everything should be styled. You should clone [the main Playbooks repository](https://gitlab.com/ProfessorManhattan/Playbooks), initialize all the submodules, and search through the code base to see how we are *styling* different task types. Below are some examples:

### Arrays

When there is only one parameter, then you should inline it.

**BAD**

```yaml
when:
  - install_minikube
...
when:
  - install_minikube
  - install_hyperv_plugin
```

**GOOD**

```yaml
when: install_minikube
...
when:
  - install_minikube
  - install_hyperv_plugin
```

### Alphabetical Order

Anywhere an array/list is used, the list should be ordered alphabetically (if possible).

**BAD**

```yaml
autokey_dependencies:
  - pkg-config
  - make
  - git
```

**GOOD**

```yaml
autokey_dependencies:
  - git
  - make
  - pkg-config
```

### main.yml

The format in `tasks/main.yml` of each role should follow roughly the same format:

**GOOD**

```yaml
---
- name: Include variables based on the operating system
  include_vars: "ansible_os_family.yml"

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: "install-ansible_os_family.yml"
```

### Dependency Variables

In most cases, a role will require that dependencies are met before installing the software the role is intended for. These dependencies are usually an array of packages that need to be installed. These dependencies should be seperated out into an array.

For example, say the application being installed is Android Studio. The dependency array should be assigned to a variable titled `androidstudio_dependencies` and placed in `vars/main.yml`.

**BAD**

```yaml
- name: "Ensure app_name's dependencies are installed"
  community.general.pacman:
    name: "android_studio_deps"
    state: present
```

**GOOD**

```yaml
- name: "Ensure app_name's dependencies are installed"
  community.general.pacman:
    name: "androidstudio_dependencies"
    state: present
```

If there are dependencies that are specific to a certain OS, then the dependency variable should be titled `androidstudio_dependencies_os_family`. For Android Studio, a Fedora-specific dependency list should be named `androidstudio_dependencies_fedora`. In practice, this would look like:

```yaml
- name: "Ensure app_name's dependencies are installed (Fedora)"
  dnf:
    name: "androidstudio_dependencies_fedora"
    state: present
  when: ansible_distribution == 'Fedora'
```

### DRY

DRY stands for "Don't Repeat Yourself." Whenever there is code that is duplicated across multiple task files, you should seperate it into a different file and then include it:

**GOOD**

```yaml
- name: Run generic Linux tasks
  include_tasks: install-Linux.yml
```



[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#testing)

## ➤ Testing

You can test all of the operating systems we support by running the following command in the root of the project:

```shell
molecule test
```

The command `molecule test` will spin up VirtualBox VMs for all the OSes we support and run the role(s). *Do this before committing code.* If you are committing code for only one OS and can not create the fix/feature for the other operating systems then please [file a seperate issue](https://gitlab.com/ProfessorManhattan/Playbooks/-/issues/new) to track the unworking OSes.

### Idempotence

It is important to note that `molecule test` tests for idempotence. This means that if you run the role twice in a row, then Ansible should not report any changes the second time around.

### Debugging

If you would like to shell into a container for debugging, you can do that by running:

```shell
molecule converge
molecule login
```

### Molecule Documentation

For more information about Ansible Molecule, check out [the docs](https://molecule.readthedocs.io/en/latest/).

### Testing Desktop Environments

Some of our roles include applications like Android Studio. You can not fully test Android Studio from a Docker command line. In cases like this, you should use our desktop scenarios to test things like:

* Making sure the Android Studio shortcut is in the applications menu
* Opening Android Studio to make sure it is behaiving as expected
* Seeing if there is anything we can automate (e.g. if there is a "Terms of Usage" you have to click OK at, then we should automate that process if possible)

You can specify which scenario you want to test by passing the -s flag with the name of the scenario you want to run. For instance, if you wanted to test on Ubuntu Desktop, you would run the following command:

```shell
molecule test -s ubuntu-desktop
```

This would run the Molecule test on Ubuntu Desktop. By default, the `molecule test` command will destroy the VM after the test is complete. To run the Ubuntu Desktop test and then open the desktop GUI you would have to:

1. Run `molecule converge -s ubuntu-desktop`
2. Open the VM through the VirtualBox UI (the username and password are both *vagrant*)

You can obtain a list of all possible scenarios by looking in the `molecule/` folder. The `molecule/default/` folder is run when you do not pass a scenario and all the other scenarios/folders can be run by manually specifying the scenario as documented above.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#linting)

## ➤ Linting

The process of running linters is mostly automated. Molecule is configured to lint so you will see linting errors when you run `molecule test` (if your code has any). There are a few gaps that are filled in by [pre-commit](https://pre-commit.com/). If you followed the [Setting Up Development Environment](), you should have noticed that one of the lines you need to execute to set up the project is:

```shell
pre-commit install
```

After installing pre-commit, your code will be automatically be sent through several different linting and formatting engines whenever you run `git commit`. **In general, you should fix all linting errors instead of adding rules to ignore the lint error.** In the following sections, we will give tips on resolving specific lint errors.

### ansible-lint

You can manually run ansible-lint by executing the following command in the project's root:

```shell
pip3 install -r requirements
ansible-lint
```

Most errors will be self-explanatory and simple to fix. Other errors might require testing and research. Below are some tips on fixing the trickier errors.

#### [208] File permissions unset or incorrect

Do some research to figure out the minimum permissions necessary for the file. After you change the permission, test the role because changing file permissions often results in causing errors.

#### [301] Command should not change things if nothing needs doing

This error can be solved by telling Ansible what files the command creates or deletes. When you specify what file a `command:` or `shell:` creates/deletes, Ansible will check for the presence/absence of the file to determine if the system is already in the desired state. If it is in the desired state, then Ansible skips the task. Refer to the [documentation for ansible.builtin.command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html) for further details.

Here is a quick example that will remove the error:

```yaml
- name: Run command if /path/to/database does not exist (with 'args' keyword)
  command: /usr/bin/make_database.sh db_user db_name
  args:
    creates: /path/to/database # If the command deletes something, then you can swap out creates with removes
```

#### [305] Use shell only when shell functionality is required

We should only be using Ansible's shell task when absolutely necessary. If you get this error then test if replacing `shell:` with `command:` resolves the error. If that does not work, then you can add a comment at the end of the line that says `# noqa 305`.