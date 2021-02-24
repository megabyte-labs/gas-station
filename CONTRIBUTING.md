# Contributing

## Getting Started

The following has been tested on Ubuntu 20.04. Using these commands will help you get set up as quickly as possible. In the project root, run the following commands:

```
sudo apt-get install python3 python3-netaddr python3-pip
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
pre-commit install
```

## Supported Operating Systems

All of the roles should support the following operating systems:

- Archlinux (Latest)
- CentOS 8
- Debian 10 (buster)
- Ubuntu 20.04 (focal)
- Fedora 33
- Mac OS X/Darwin (Latest)
- Windows (Latest)

## Testing

### Testing Linux Environments with Docker

To test a role on the Linux distributions, run the following command in the role's root directory:

```
molecule test
```

The command `molecule test` will spin up Docker instances for all the Linux distributions we support and install the role. It does some other tests too. Namely, it tests for idempotence. Basically, a role that runs twice in a row should not report any changes the second time around.

If you would like to shell into the container for debugging, you can do that by running:

```
molecule converge
molecule login
```

### Testing Full Desktop Environments

Some of our roles include applications like Android Studio. You can not fully test Android Studio from a Docker CLI. In cases like this, you should use the automated VirtualBox testing scenario. Molecule can use Vagrant along with VirtualBox to create a VM and install a role. After you do this, it is important to open the VM and verify that, for example, Android Studio opens when you click on the shortcut in the quick launch menu. You can run this type of test by running the following command in the role's root directory:

```
molecule converge -s virtualbox
```

Molecule will install the role on a VM and leave the VM intact. You should then open the VM with VirtualBox and inspect the installation. **When you are doing this, try asking yourself, "How can this be improved?"** Maybe the role works and Android Studio is installed. If it is, that is great. However, when you are testing, try to imagine how we can automate more. For example:

- *The software is installed but is asking for a license key* - In this case, we should ensure that our playbook has an option for automatically installing the license key
- *The software supports plugins* - We should provide an option for specifying the plugins that can be automatically installed.
- *The software (in this case Android Studio) does not install SDKs automatically* - If this is the case, we should offer the ability to automatically install user-specified SDKs.
- *The software has configuration files with commonly tweaked settings* - We should provide the ability to change these settings from the playbook.
- *The software has the capability to integrate with another piece of software in the playbook* - The integration should be done.

And so on...

It is best if you choose to use the software provided by the playbook in your daily routine. If something is missing from the playbook that you consider essential, create an unassigned issue for it on the [GitLab issue board](https://gitlab.com/ProfessorManhattan/Playbooks/-/issues).

## Linting

There are primarily two different linting tools used in this playbook. They are **ansible-lint** and **yamllint**. ansible-lint lint offers code suggestions related to Ansible best practices and yamllint offers generic code suggestions for .yml files.

First off, you need to install yamllint. This requires Python to be installed. Here's a sample set of commands that will get you set up on Ubuntu 20.04:

```
sudo apt get python3 python3-pip
pip3 install -r requirements.txt
```

### yamllint Instructions

After you have Python and yamllint installed, you can start linting:

1. Go to the root of the project
1. Run the command `yamllint .`

You should see any linting errors that were found. After you fix some of the errors, commit your changes to the `yamllint` branch. This will allow multiple developers to fix errors at the same time (and prevent double work) since your working directory will be linked to the same repository. In general, you can fix all of the errors except for the _line too long_ error - suggestions on addressing this error are welcome.

### ansible-lint Instructions

First, make sure you have the requirements installed with `pip3 install -r requirements`.

After ansible-lint is installed, you can see the ansible-lint errors by running `ansible-lint` in the root directory. Some of the errors are self-expanatory and simple to fix. Other errors might require testing and research. Tips on fixing the trickier errors are listed below.

#### [208] File permissions unset or incorrect

Do some research and figure out the minimum necessary permissions for the file. After you change the permission, test the role.

#### [301] Commands should not change things if nothing needs doing

This error will go away if you tell Ansible what files the command creates or deletes. Ansible will check if the command has already created or deleted a file and only run the command if the system appears to be in the desired state. You should look at the [documentation for command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html). Here's a quick example that will get rid of this lint error:

```
- name: Run command if /path/to/database does not exist (with 'args' keyword)
  command: /usr/bin/make_database.sh db_user db_name
  args:
    creates: /path/to/database # If the command deletes something, then you can swap out creates with removes
```

#### [305] Use shell only when shell functionality is required

We should only be using Ansible's shell feature when absolutely necessary. First, test whether or not the role works by replacing shell: with command:. If it works, then change it to command. If it does not, then add a comment at the end of the line that says `# noqa 305`.

## Style

### When only one parameter is required, inline it

**BAD:**

```
when:
    - install_minikube
```

**GOOD:**

```
when: install_minikube
```

#### All roles `main.yml` file should be roughly the same

The format in the majority of the `tasks/main.yml` files inside of roles should be the same. The format is:

```
---
- name: Include variables based on the operating system
  include_vars: "{{ ansible_os_family }}.yml"

- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: "install-{{ ansible_os_family }}.yml"
```

However, when the role is complete, if the variable files are all unused, then you can delete all of the OS-specific variable files as well as the first task in the snippet above. The `tasks/main.yml` file would then look like this:

```
---
- name: Include tasks based on the operating system
  become: true
  block:
    - include_tasks: "install-{{ ansible_os_family }}.yml"
```

#### Where possible, use the DRY principle

DRY stands for Do NOT Repeat Yourself. Whenever there is code that is duplicated across multiple task files, you should seperate it into a different file and then include it like this:

```
- name: Run generic Linux tasks
  include_tasks: install-Linux.yml
```

#### Handling dependencies

Some software components need dependencies to be satisfied before they can be installed. A good example of such a case is installing packages from Archlinux's AUR repository. The package information page lists the dependencies. These packages need to be added to the _Archlinux.yml_ variable file as `<package>_dependencies` (replace `<package>` with the name of the package, e.g: `autokey_dependencies`), and install these in the Playbook. The format of this task is shown below:

```
- name: "Ensure {{ app_name }}'s dependencies are installed"
  community.general.pacman:
    name: "{{ <package>_dependencies }}"
    state: present
```

If there are dependencies that are specific to a certain distribution in a OS family, then list the dependencies in the corresponding variable file. For example, to add dependencies for Fedora, add the variable `<package>_dependencies_fedora` to the _RedHat.yml_ variable file. Install these packages in the Playbook, using the below format:

```
- name: "Ensure {{ app_name }}'s dependencies are installed (Fedora)"
  dnf:
    name: "{{ <package>_dependencies_fedora }}"
    state: present
  when: ansible_distribution == 'Fedora'
```

#### Ordering lists

Anywhere a list is used, ensure to order the list. An example is given below:

```
autokey_dependencies:
  - binutils
  - fakeroot
  - gcc
  - git
  - make
  - pkg-config
```
