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
