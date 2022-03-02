<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-contributing.md" ⚠️--><div align="center">
  <center><h1 align="center">Contributing Guide</h1></center>
</div>

First of all, thanks for visiting this page 😊 ❤️ ! We are _stoked_ that you may be considering contributing to this project. You should read this guide if you are considering creating a pull request or plan to modify the code for your own purposes.

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Philosophy](#philosophy)
- [Supported Operating Systems](#supported-operating-systems)
  - [Other Operating Systems](#other-operating-systems)
  - [Code Style for Platform-Specific Roles](#code-style-for-platform-specific-roles)
  - [Preferred Installation Method for Mac OS X](#preferred-installation-method-for-mac-os-x)
- [Setting Up Development Environment](#setting-up-development-environment)
  - [Requirements](#requirements)
  - [Getting Started](#getting-started)
  - [Tasks Available](#tasks-available)
- [Pull Requests](#pull-requests)
- [Code Format](#code-format)
  - [Code Format Example](#code-format-example)
  - [Platform-Specific Roles](#platform-specific-roles)
- [Code Style](#code-style)
  - [Arrays](#arrays)
  - [Alphabetical Order](#alphabetical-order)
  - [Dependency Variables](#dependency-variables)
  - [DRY](#dry)
- [Commenting](#commenting)
  - [Variable Comments](#variable-comments)
  - [Action Comments](#action-comments)
    - [Example Action Comment Implementation](#example-action-comment-implementation)
    - [Example Action Comment Generated Output](#example-action-comment-generated-output)
    - [Action Comment Guidelines](#action-comment-guidelines)
  - [TODO Comments](#todo-comments)
    - [Example TODO Comment Implementation](#example-todo-comment-implementation)
    - [Example TODO Comment Generated Output](#example-todo-comment-generated-output)
    - [TODO Comment Guidelines](#todo-comment-guidelines)
- [Updating Meta Files and Documentation](#updating-meta-files-and-documentation)
  - [The `"blueprint" package.json` Field and `@appnest/readme`](#the-blueprint-packagejson-field-and-appnestreadme)
  - [`meta/main.yml` Description](#metamainyml-description)
  - [`logo.png`](#logopng)
- [Testing](#testing)
  - [Idempotence](#idempotence)
  - [Debugging](#debugging)
  - [Molecule Documentation](#molecule-documentation)
  - [Testing Desktop Environments](#testing-desktop-environments)
  - [Molecule Scenario Descriptions](#molecule-scenario-descriptions)
  - [Continuous Integration (CI)](#continuous-integration-ci)
- [Linting](#linting)
  - [Fixing Ansible Lint Errors](#fixing-ansible-lint-errors)
    - [[208] File permissions unset or incorrect](#208-file-permissions-unset-or-incorrect)
    - [[301] Command should not change things if nothing needs doing](#301-command-should-not-change-things-if-nothing-needs-doing)
    - [[305] Use shell only when shell functionality is required](#305-use-shell-only-when-shell-functionality-is-required)

<a href="#code-of-conduct" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](https://github.com/ProfessorManhattan/ansible-homebrew/blob/master/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [help@megabyte.space](mailto:help@megabyte.space).

<a href="#philosophy" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Philosophy

When you are working with one of our Ansible projects, try asking yourself, "**How can this be improved?**" For example, in the case of the [Android Studio role](https://github.com/ProfessorManhattan/ansible-androidstudio), the role installs Android Studio but there may be additional tasks that should be automated. Consider the following examples:

- _The software is installed but is asking for a license key._ - In this case, we should provide an option for automatically installing the license key using a CLI command.
- _The software supports plugins_ - We should provide an option for specifying the plugins that are automatically installed.
- _In the case of Android Studio, many users have to install SDKs before using the software._ - We should offer the capability to automatically install user-specified SDKs.
- _The software has configuration files with commonly tweaked settings._ - We should provide the ability to change these settings via variables stored in `defaults/main.yml`.
- _The software has the capability to integrate with another piece of software in the [main playbook](repository.playbooks)_. - This integration should be automated.

Ideally, you should use the software installed by the [main playbook](repository.playbooks). This is really the only way of testing whether or not the software was installed properly and has all the common settings automated. The software installed by the main playbook is all widely-acclaimed, cross-platform software that many people find useful.

<a href="#supported-operating-systems" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Supported Operating Systems

All of our roles should run without error on the following operating systems:

- Archlinux (Latest)
- CentOS 7 and 8
- Debian 9 and 10
- Fedora (Latest)
- Ubuntu (16.04, 18.04, 20.04, and Latest)
- Mac OS X (Latest)
- Windows 10 (Latest)

### Other Operating Systems

Although we do not have a timeline set up, we are considering adding support for the following operating systems:

- **Qubes**
- Elementary OS
- Zorin
- OpenSUSE
- Manjaro
- FreeBSD
- Mint

### Code Style for Platform-Specific Roles

If you have a role that only installs software made for Windows 10 then ensure that the tasks are only run when the system is a Windows system by using `when:` in the `tasks/main.yml` file. Take the following `main.yml` as an example:

```yaml
---
- name: Include variables based on the operating system
  include_vars: 'ansible_os_family.yml'
  when: ansible_os_family == 'Windows'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: 'install-ansible_os_family.yml'
  when: ansible_os_family == 'Windows'
```

### Preferred Installation Method for Mac OS X

We currently support installing applications with both [Homebrew](https://brew.sh/) casks and [mas](https://github.com/mas-cli/mas). Since mas does not allow automated logins to the App Store (and requires that the application was already installed by the account signed into the App Store GUI), we prefer the use of homebrew casks for installing applications.

<a href="#setting-up-development-environment" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Setting Up Development Environment

Before contributing to this project, you will have to make sure you have the tools that are utilized. We have made it incredibly easy to get started - just run `bash .start.sh` in the root of the repository. Most of the requirements (listed below) will automatically install (rootlessly) if they are missing from your system when you initialize the project by running `bash .start.sh`.

### Requirements

- **[Task](https://github.com/ProfessorManhattan/ansible-task)**
- **[Python 3](https://github.com/ProfessorManhattan/ansible-python)**, along with the `python3-netaddr` and `python3-pip` libraries (i.e. `sudo apt-get install python3 python3-netaddr python3-pip`)
- **[Docker](https://github.com/ProfessorManhattan/ansible-docker)**
- **[Node.js](https://github.com/ProfessorManhattan/ansible-nodejs)** >=12 which is used for the development environment which includes a pre-commit hook
- **[VirtualBox](https://github.com/ProfessorManhattan/ansible-virtualbox)** which is used for running Molecule tests

Docker and VirtualBox must be installed with root priviledges. If they are missing from your system, running `bash .start.sh` will prompt you for your password and automatically install them. Otherwise, you can follow the official [directions for installing Docker](https://docs.docker.com/get-docker/) and [directions for installing VirtualBox](https://www.virtualbox.org/manual/ch02.html).

### Getting Started

With all the requirements installed, navigate to the root directory and run the following command to set up the development environment which includes installing the Python dependencies and installing the Ansible Galaxy dependencies:

```terminal
bash .start.sh
```

This will install all the dependencies and automatically register a pre-commit hook. More specifically, `bash .start.sh` will:

1. Install Task which provides an easy-to-use interface for performing common tasks while leveraging parallel execution
2. Install missing development tools like Node.js and Python
3. Install the Node.js development environment dependencies
4. Install a pre-commit hook using [husky](https://www.npmjs.com/package/husky)
5. Ensure that meta files and documentation are up-to-date
6. Install the Python 3 requirements
7. Install the Ansible Galaxy requirements
8. Re-generate documentation using the latest sources
9. Perform other miscellaneous tasks depending on the project type

### Tasks Available

With the dependencies installed, you can see a list of the available commands by running `task --list`. This will log a help menu to the console informing you about the available commands and what they do. After running the command, you will see something that looks like this:

```shell
❯ task --list

task_list_output
```

Using the information provided above by running `task --list`, we can see that the `task lint:all` command will lint the project with all the available linters. You can see exactly what each command is doing by checking out the `Taskfile.yml` file (and following the imports). You can also get a detailed summary of any task reported by `task --list` by running `task group:task-name --summary`.

<a href="#pull-requests" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Pull Requests

All pull requests should be associated with issues. Although not strictly required, the pull requests should be made to [the GitLab repository issues board](https://gitlab.com/megabyte-labs/ansible-roles/homebrew/-/issues) instead of the [GitHub mirror repository](https://github.com/ProfessorManhattan/ansible-homebrew/issues). This is because we use GitLab as our primary repository and mirror the changes to GitHub for the community.

<a href="#code-format" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Code Format

We try to structure our Ansible task and variable files consistently across all [our Ansible projects](https://gitlab.com/megabyte-labs/ansible-roles). This allows us to do things like use RegEx to make ecosystem wide changes. A good way of making sure that your code follows the format we are using is to:

1. Clone the [main playbook repository](project.playbooks) (a.k.a. [Install Doctor](https://install.doctor))
2. Use Visual Studio Code to search for code examples of how we are performing similar tasks

For example:

- All of our roles use a similar pattern for the `tasks/main.yml` file
- The file names and variable names are consistent across our roles
- Contributors automatically format some parts of their code by leveraging our pre-commit hook (which is installed when you run `bash .start.sh` in the root of a project)

### Code Format Example

To dive a little deeper, take the following block of code that was retrieved from the `tasks/main.yml` file in the [Android Studio role](https://github.com/InstallDoc/androidstudio) as an example:

```yaml
---
- name: Include variables based on the operating system
  include_vars: '{{ ansible_os_family }}.yml'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: 'install-{{ ansible_os_family }}.yml'
```

If you compare the block of code above to other `tasks/main.yml` files in other roles (which you can find in our [Ansible Roles group](https://gitlab.com/megabyte-labs/ansible-roles) or our [main playbook](project.playbooks)) (a.k.a. [Install Doctor](https://install.doctor)), you will see that the files are either identical or nearly identical. There is an exception. Some roles will exclude the first task titled "Include variables based on the operating system" when variables are not required for the role. Our goal is to be consistent but not to the point where we are degrading the functionality of our code or including code that is unnecessary.

In general, it is up to the developer to browse through our projects to get a feel for the code format we use. A good idea is to clone [Install Doctor](project.playbooks), search for how Ansible modules are used, and then mimic the format. For instance, if you are adding a task that installs a snap package, then you would search for `community.general.snap:` in the main playbook to see the format we are using so you can mimic the style.

### Platform-Specific Roles

If you have a role that only installs software made for Windows 10 then ensure that the tasks are only run when the system is a Windows system by using `when:` in the `tasks/main.yml` file. Take the following `main.yml` as an example:

```yaml
---
- name: Include variables based on the operating system
  include_vars: 'ansible_os_family.yml'
  when: ansible_os_family == 'Windows'

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: 'install-ansible_os_family.yml'
  when: ansible_os_family == 'Windows'
```

<a href="#code-style" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Code Style

We try to follow the same code style across all our Ansible repositories. If something is done one way somewhere, then it should be done the same way elsewhere. It is up to you to [browse through our roles](https://gitlab.com/megabyte-labs/ansible-roles) to get a feel for how everything should be styled. You should clone [the main playbooks repository](project.playbooks) (a.k.a. [Install Doctor](https://install.doctor)), initialize all the submodules either via `bash .start.sh` or `git submodule update --init --recursive`, and search through the code base to see how we are _styling_ different task types. Below are some examples:

### Arrays

When there is only one parameter, then you should inline it.

**❌ BAD**

```yaml
when:
  - install_minikube
```

**✅ GOOD**

```yaml
when: install_minikube
```

**✅ ALSO GOOD**

```yaml
when:
  - install_minikube
  - install_hyperv_plugin
```

### Alphabetical Order

Anywhere an array/list is used, the list should be ordered alphabetically (if possible).

**❌ BAD**

```yaml
autokey_dependencies:
  - pkg-config
  - make
  - git
```

**✅ GOOD**

```yaml
autokey_dependencies:
  - git
  - make
  - pkg-config
```

### Dependency Variables

In many cases, a role will require that specific software package dependencies are met before running. These dependencies are usually an array of packages that need to be installed.

Say the application being installed is Android Studio. The dependency array should be assigned to a variable titled `androidstudio_dependencies` (where "androidstudio" is retrieved from the `.galaxy_info.role_name` field in the `meta/main.yml` file) and placed in `vars/main.yml`.

**✅ GOOD example of defining the variable in the `vars/main.yml` file**

```yaml
---
androidstudio_dependencies:
  - ffmpeg
  - coolpackage
  - anotherpackage
```

**❌ BAD example of integrating the variable into a task file:**

```yaml
- name: "Ensure {{ app_name }}'s dependencies are installed"
  community.general.pacman:
    name: '{{ android_studio_deps }}'
    state: present
```

**✅ GOOD example of integrating the variable into a task file:**

```yaml
- name: "Ensure {{ app_name }}'s dependencies are installed"
  community.general.pacman:
    name: '{{ androidstudio_dependencies }}'
    state: present
```

If there are dependencies that are specific to a certain OS, then the dependency variable should be titled `{{ .galaxy_info.role_name }}_dependencies_{{ os_family }}`. For Android Studio, a Fedora-specific dependency list should be named `androidstudio_dependencies_fedora`. In practice, this would look like:

```yaml
- name: "Ensure {{ app_name }}'s dependencies are installed (Fedora)"
  dnf:
    name: '{{ androidstudio_dependencies_fedora }}'
    state: present
  when: ansible_distribution == 'Fedora'
```

### DRY

DRY stands for "Don't Repeat Yourself." Whenever there is code that is duplicated across multiple task files, you should separate it into a different file and then include it like in the following example:

**✅ GOOD**

```yaml
- name: Run generic Linux tasks
  include_tasks: install-Linux.yml
```

<a href="#commenting" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Commenting

We strive to make our roles easy to understand. Commenting is a major part of making our roles easier to grasp. Several types of comments are supported in such a way that they are extracted and injected into our documentation. This project uses [mod-ansible-autodoc](https://pypi.org/project/mod-ansible-autodoc/) (a pet project of ours and a fork of [ansible-autodoc](https://pypi.org/project/ansible-autodoc/)) to scan through specially marked up comments and generate documentation out of them. The module also allows the use of markdown in comments so feel free to **bold**, _italicize_, and `code_block` as necessary. Although it is perfectly acceptable to use regular comments, in most cases you should use one of the following types of _special_ comments:

- [Variable comments](#variable-comments)
- [Action comments](#action-comments)
- [TODO comments](#todo-comments)

### Variable Comments

It is usually not necessary to add full-fledged comments to anything in the `vars/` folder but the `defaults/main.yml` file is a different story. The `defaults/main.yml` file must be fully commented since it is where we store all the variables that our users can customize. **`defaults/main.yml` is the only place where comments using the following format should be present.**

Each variable in `defaults/main.yml` should be added and documented using the following format:

<!-- prettier-ignore-start -->
```yaml
 # @var variable_name: default_value
 # The description of the variable which should be no longer than 160 characters per line.
 # You can separate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: default_value
```
<!-- prettier-ignore-end -->

There may be cases where an example is helpful. In these cases, use the following format:

<!-- prettier-ignore-start -->
```yaml
 # @var variable_name: []
 # The description of the variable which should be no longer than 160 characters per line.
 # You can separate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: []
 # @example #
 # variable_name:
 #   - name: jimmy
 #     param: henry
 #   - name: albert
 # @end
```
<!-- prettier-ignore-end -->

Each variable-comment block in `defaults/main.yml` should be separated by a line return. You can see an example of a `defaults/main.yml` file using this special [variable syntax in the Docker role](https://github.com/ProfessorManhattan/ansible-docker/blob/master/defaults/main.yml).

### Action Comments

Action comments allow us to describe what the role does. Each action comment should include an action group as well as a description of the feature or "action". Most of the action comments should probably be added to the `tasks/main.yml` file although there could be cases where an action comment is added in a specific task file (like `install-Darwin.yml`, for instance). Action comments allow us to group similar tasks into lists under the action comment's group.

#### Example Action Comment Implementation

The following is an example of the implementation of action comments. You can find the [source here](https://github.com/ProfessorManhattan/ansible-docker/blob/master/tasks/main.yml) as well as an example of why and how you would include an [action comment outside of the `tasks/main.yml` file here](https://github.com/ProfessorManhattan/ansible-docker/blob/master/tasks/compose-Darwin.yml).

<!-- prettier-ignore-start -->
```yaml
 # @action Ensures Docker is installed
 # Installs Docker on the target machine.
 # @action Ensures Docker is installed
 # Ensures Docker is started on boot.
 - name: Include tasks based on the operating system
   block:
     - include_tasks: 'install-{{ ansible_os_family }}.yml'
   when: not docker_snap_install

 # @action Ensures Docker is installed
 # If the target Docker host is a Linux machine and the `docker_snap_install` variable
 # is set to true, then Docker will be installed as a snap package.
 - name: Install Docker via snap
   community.general.snap:
     name: docker
   when:
     - ansible_os_family not in ('Windows', 'Darwin')
     - docker_snap_install

 # @action Installs Docker Compose
 # Installs Docker Compose if the `docker_install_compose` variable is set to true.
 - name: Install Docker Compose (based on OS)
   block:
     - include_tasks: 'compose-{{ ansible_os_family }}.yml'
   when: docker_install_compose | bool
```
<!-- prettier-ignore-end -->

#### Example Action Comment Generated Output

The block of code above will generate markdown that would look similar to this:

**Ensures Docker is installed**

- Installs Docker on the target machine.
- Ensures Docker is started on boot.
- If the target Docker host is a Linux machine and the `docker_snap_install` variable is set to true, then Docker will be installed as a snap package.

**Installs Docker Compose**

- Installs Docker Compose if the `docker_install_compose` variable is set to true.

#### Action Comment Guidelines

- The wording of each action should be in active tense, describing a capability of the role. So instead of calling an action "Generate TLS certificates," we would call it, "Generates TLS certificates."
- The bulk of the action comments should be placed in the `tasks/main.yml` file. However, there may be use cases for putting an action comment in another file. For instance, if the business logic is different for Windows hosts, then we might add action comments to the `install-Windows.yml` file explaining the different logic.
- The goal of action comments are to present our users with some easy to understand bullet points about exactly what the role does and also elaborate on some of the higher-level technical details.

### TODO Comments

TODO comments are similar to action comments in the sense that through automation similar comments will be grouped together. You should use them anytime you find a bug, think of an improvement, spot something that needs testing, or realize there is a desirable feature missing. Take the following as an example:

#### Example TODO Comment Implementation

<!-- prettier-ignore-start -->
```yaml
  # @todo Bug: bug description
  # @todo improvement: improvement description
  # @todo Bug: another bug description
```
<!-- prettier-ignore-end -->

#### Example TODO Comment Generated Output

The above code will output something that looks like this:

**Bug**

- bug description
- another bug description

**improvement**

- improvement description

Notice how the title for _improvement_ is not capitalized. It should be capitalized so make sure you pay attention to that detail.

#### TODO Comment Guidelines

- A TODO comment can be placed anywhere as long as no lines pass the limit of 160 characters.
- Try using similar TODO comment groups. Nothing is set in stone yet but try to use the following categories unless you really believe we need a new category:
  - Bug
  - Feature
  - Improvement
  - Test
- Ensure you capitalize the category

<a href="#updating-meta-files-and-documentation" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Updating Meta Files and Documentation

Since we have hundreds of Ansible roles to maintain, the majority of the files inside each role are shared across all our Ansible projects. We synchronize these common files across all our repositories with various build tools. When you clone a new repository, the first command you should run is `bash .start.sh`. This will install missing software requirements, run the full update sequence, and ensure everything is up-to-date. To synchronize the project at a later point in time, you can run `task common:update` which runs most of the logic executed by running `bash .start.sh`.

### The `"blueprint" package.json` Field and `@appnest/readme`

In the root of all of our Ansible repositories, we include a file named `package.json`. In the key named `"blueprint"`, there are variables that are used in our build tools. Most of the variables stored in `"blueprint"` are used for generating documentation. All of our documentation is generated using variables and document partials that we feed into a project called `[@appnest/readme](https://github.com/andreasbm/readme)` (which is in charge of generating the final README/CONTRIBUTING guides). When `@appnest/readme` is run, it includes the variables stored in `"blueprint"` in the context that it uses to inject variables in the documentation. You can view the documentation partials by checking out the `./.common` folder which is a submodule that is shared across all of our Ansible projects.

For every role that is included in our eco-system, we require certain fields to be filled out in the `"blueprint"` section of the `package.json` file. Lucky for you, most of the fields in the file are auto-generated. The fields that need to be filled out as well as descriptions of what they should contain are listed in the chart below:

| Variable Name       | Variable Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `description`       | Short description of the role, worded in such a way that it makes sense by itself and with 'An Ansible role that ' prepended to it                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `group`             | This should always be set to 'ansible' for Ansible roles                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `name`              | This should be the official name for the product that the role installs/configures. It is used in the title of the repository and throughout the documentation to refer to the product.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `overview`          | This variable should be a description of what the role installs. You can usually find a good description by Googling, "What is Android Studio," for example if you were populating this variable for the [Android Studio role]({{ repository.group.ansible_roles }}/androidstudio). This text is shown at the top of the README, right below the header section and before the table of contents. Whenever possible, key products/terms should be linked to using markdown. You can see an example of us hyperlinking in this variable by checking out the [Android Studio role]({{ repository.group.ansible_roles }}/androidstudio). The idea is to make it as easy as possible for our users to figure out exactly what the role does. |
| `repository.github` | The HTTPS URL of the GitHub mirror                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `repository.gitlab` | The HTTPS URL of the GitLab repository                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `slug`              | This should generally be the ending slug of the GitHub mirror. It is used for things like filling in the package.json name.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `subgroup`          | This should always be set to 'role' for Ansible roles                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `title`             | The title of the README.md                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

### `meta/main.yml` Description

The most important piece of text in each of our Ansible projects is the [Ansible Galaxy](https://galaxy.ansible.com) description located in `meta/main.yml`. This text is used in search results on Ansible Galaxy and GitHub. It is also spun to generate multiple variants so it has to be worded in a way that makes sense with our different variants. Take the following as an example:

**The `meta/main.yml` description example:**

- Installs Android Studio and sets up Android SDKs on nearly any OS

**Gets spun and used by our automated documentation framework in the following formats:**

- Installs Android Studio and sets up Android SDKs on nearly any OS
- An Ansible role that _installs Android Studio and sets up Android SDKs on nearly any OS_
- This repository is the home of an Ansible role that _installs Ansible Studio and sets up Android SDKs on nearly any OS_.

It is important that all three variants of the `meta/main.yml` description make sense and be proper English. The `meta/main.yml` description should succinctly describe what the role does and possibly even describe what the product does if it is not well-known like Android Studio. An example of a description that includes an overview of the product would be something like, "Installs HTTPie (a user-friendly, command-line HTTP client) on nearly any platform," for the [HTTPie role](https://github.com/ProfessorManhattan/ansible-httpie) or "Installs Packer (an automation tool for building machine images) on nearly any platform" for the [Packer role](https://github.com/ProfessorManhattan/ansible-packer).

### `logo.png`

We include a `logo.png` file in all of our Ansible projects. This image is automatically integrated with GitLab so that a thumbnail appears next to the project. It is also shown in the README to give the user a better idea of what the role does. All roles should include the `logo.png` file. When adding a `logo.png` file please _strictly_ adhere to the steps below:

1. Use Google image search to find a logo that best represents the product. Ensure the image is a `.png` file and that it has a transparent background, if possible. Ideally, the image should be the official logo for software that the Ansible role/project installs. The image should be at least 200x200 pixels.
2. After downloading the image, ensure you have the sharp-cli installed by running `npm install -g sharp-cli`.
3. Resize the image to 200x200 pixels by running `sharp -i file_location.png -o logo.png resize 200 200`.
4. Compress the resized image by dragging and dropping the resized image into the [TinyPNG web application](https://tinypng.com/).
5. Download the compressed image and add it to the root of the Ansible project. Make sure it is named `logo.png`.

Alternatively, you can use our pre-commit hook to automatically take care of steps 2-5 when the `logo.png` file is staged with git.

<a href="#testing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Testing

You can test all of the operating systems we support by running the following command in the root of the project:

```shell
molecule test
```

The command `molecule test` will spin up VirtualBox VMs for all the OSes we support and run the role(s). _Do this before committing code._ If you are committing code for only one OS and can not create the fix or feature for the other operating systems then please, at the very minimum, [file an issue](https://gitlab.com/megabyte-labs/ansible-roles/homebrew* **github**: /issues

- **gitlab**: /-/issues) so someone else can pick it up.

### Idempotence

It is important to note that `molecule test` tests for idempotence. To pass the idempotence test means that if you run the role twice in a row then Ansible should not report any changes the second time around.

### Debugging

If you would like to shell into a container for debugging, you can do that by running:

```shell
task common:shell
```

### Molecule Documentation

For more information about Ansible Molecule, check out [the docs](https://molecule.readthedocs.io/en/latest/).

### Testing Desktop Environments

Some of our roles include applications like [Android Studio](https://github.com/ProfessorManhattan/ansible-androidstudio). You can not fully test Android Studio from a Docker command line. In cases like this, you should use our desktop scenarios to provision a desktop GUI-enabled VM to test things like:

- Making sure the Android Studio shortcut is in the applications menu
- Opening Android Studio to make sure it is behaving as expected
- Seeing if there is anything we can automate (e.g. if there is a "Terms of Usage" you have to click OK at then we should automate that process if possible)

You can specify which scenario you want to test by passing the `-s` flag with the name of the scenario you want to run. For instance, if you wanted to test on Ubuntu Desktop, you would run the following command:

```shell
molecule test -s ubuntu-desktop
```

This would run the Molecule test on Ubuntu Desktop.

By default, the `molecule test` command will destroy the VM after the test is complete. To run the Ubuntu Desktop test and then open the desktop GUI you would have to:

1. Run `molecule converge -s ubuntu-desktop`
2. Open the VM through the VirtualBox UI (the username and password are both _vagrant_)

You can obtain a list of all possible scenarios by looking in the `molecule/` folder. The `molecule/default/` folder is run when you do not pass a scenario. All the other scenarios can be run by manually specifying the scenario (e.g. `molecule test -s ubuntu-desktop` will run the test using the scenario in `molecule/ubuntu-desktop/`).

### Molecule Scenario Descriptions

The chart below provides a list of the scenarios we include in all of our Ansible projects along with a brief description of what they are included for.

| Scenario                | Description                                                                                                            |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `default`               | Uses VirtualBox to run tests for all platforms in parallel.                                                            |
| `docker`                | Uses Docker to run tests for all Linux platforms and versions in parallel.                                             |
| `docker-snap`           | The same as the `docker` scenario except it excludes platforms that have trouble installing snap packages on Docker.   |
| `archlinux-desktop`     | Runs the test on the latest version of Archlinux desktop using VirtualBox.                                             |
| `centos-desktop`        | Runs the test on the latest version of CentOS desktop using VirtualBox.                                                |
| `debian-desktop`        | Runs the test on the latest version of Debian desktop using VirtualBox.                                                |
| `fedora-desktop`        | Runs the test on the latest version of Fedora desktop using VirtualBox.                                                |
| `macos-desktop`         | Runs the test on the latest version of macOS desktop using VirtualBox.                                                 |
| `ubuntu-desktop`        | Runs the test on the latest version of Ubuntu desktop using VirtualBox.                                                |
| `windows-desktop`       | Runs the test on the latest version of Windows desktop using VirtualBox.                                               |
| `ci-docker-archlinux`   | Uses Docker to test Archlinux.                                                                                         |
| `ci-docker-centos`      | Uses Docker to test multiple versions of CentOS.                                                                       |
| `ci-docker-debian`      | Uses Docker to test multiple versions of Debian.                                                                       |
| `ci-docker-debian-snap` | Uses Docker to test Debian just like `ci-docker-debian` except it excludes versions that cannot install snap packages. |
| `ci-docker-fedora`      | Uses Docker to test multiple versions of Fedora.                                                                       |
| `ci-docker-ubuntu`      | Uses Docker to test multiple versions of Ubuntu.                                                                       |

### Continuous Integration (CI)

You might have noticed that there are no CI tests in the chart above for macOS and Windows. Due to the limitations of Docker, we use other methods to test macOS and Windows automatically with CI. After a project has passed various linting tests on GitLab CI, the following methods are used to test the Ansible play:

- Linux platforms are tested using Molecule and Docker on GitLab CI in parallel. ([Link to GitLab CI configuration](https://gitlab.com/megabyte-labs/ci/-/blob/master/test/molecule.gitlab-ci.yml))
- Windows is tested using GitLab CI without Molecule. ([Link to GitLab CI configuration](https://gitlab.com/megabyte-labs/ci/-/blob/master/test/windows-ansible-test.gitlab-ci.yml))
- macOS is tested using GitHub Actions after the code is automatically synchronized between GitLab and GitHub. ([Link to the macOS GitHub Action configuration](https://github.com/ProfessorManhattan/ansible-homebrew/-/blob/master/.github/workflows/macOS.yml))

<a href="#linting" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Linting

The process of running linters is mostly automated. Molecule is configured to lint so you will see linting errors when you run `molecule test` (note that not all Molecule scenarios include automatic linting). There is also a pre-commit hook that lints your code and performs other validations before allowing a `git commit` to go through. If you followed the [Setting Up Development Environment](#setting-up-development-environment) section, you should be all set to have your code automatically linted before pushing changes to the repository.

**Please note that before creating a pull request, all lint errors should be resolved.** If you would like to view all the steps we take to ensure great code then check out `.husky/pre-commit` and the other files in the `.husky/` folder.

### Fixing Ansible Lint Errors

You can manually run Ansible Lint by executing the following command in the project's root:

```shell
task lint:ansible
```

Most errors will be self-explanatory and simple to fix. Other errors might require testing and research. Below are some tips on fixing the trickier errors.

#### [208] File permissions unset or incorrect

If you get this error, do research to figure out the minimum permissions necessary for the file. After you change the permission, test the role (since changing permissions can easily break things).

#### [301] Command should not change things if nothing needs doing

This error can be solved by telling Ansible what files the command creates or deletes. When you specify what file a `command:` or `shell:` creates and/or deletes, Ansible will check for the presence or absence of the file to determine if the system is already in the desired state. If it is in the desired state, then Ansible skips the task. Refer to the [documentation for ansible.builtin.command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html) for further details.

Here is an example of code that will remove the error:

```yaml
- name: Run command if /path/to/database does not exist
  command: /usr/bin/make_database.sh db_user db_name
  args:
    creates: /path/to/database # If the command deletes something, then you can swap out creates with removes
```

#### [305] Use shell only when shell functionality is required

Only use the Ansible `shell:` task when absolutely necessary. If you get this error then test if replacing `shell:` with `command:` resolves the error. If that does not work and you can not figure out how to properly configure the environment for `command:` to work, then you can add `# noqa 305` at the end of the line that includes the `name:` property. The same is true for other linting errors - `# noqa` followed by the reported lint error code will instruct `ansible-lint` to ignore the error.
