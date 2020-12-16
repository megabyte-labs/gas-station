# ProfessorManhattan's Playbook

This playbook is for paranoid developers - the kind of developer that reformats their computer every couple weeks. Its' primary purpose is to set up an array of computers with the _best_ software. After you reformat any of your computers, you can run this playbook which will automatically install and configure _dozens_ of useful programs, apps, and services that make development and power-using easier.

- List of software/services/apps here (coming soon)

It is easiest to install this Playbook on **Ubuntu**. To run the playbook on Ubuntu, run the following command in your terminal:

```console
bash <(wget -qO- https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/ubuntu/master-init.sh)
```

## Linting

There are two different linting tools used in this playbook. They are **ansible-lint** and **yamllint**. ansible-lint lint offers code suggestions related to Ansible best practices and yamllint offers generic code suggestions for .yml files.

### yamllint Instructions

First off, you need to install yamllint. This requires Python to be installed. Here's a sample set of commands that will get you set up on Ubuntu 20.04:

```
sudo apt get python3 python3-pip
pip3 install yamllint
```

After you have Python and yamllint installed, you can start linting:

1. Go to the root of the project
1. Run the command `yamllint .`

You should see any linting errors that were found. After you fix some of the errors, commit your changes to the `yamllint` branch. This will allow multiple developers to fix errors at the same time (and prevent double work) since your working directory will be linked to the same repository. In general, you can fix all of the errors except for the _line too long_ error - suggestions on addressing this error are welcome.

### ansible-lint Instructions

First, install ansible-lint:

```
sudo apt get python3 python3-pip
pip3 install ansible-base
pip3 install ansible-lint
```

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

## Windows

### Windows 10 Controller

The controller is responsible for running Ansible to provision other parts of
the system. There only needs to be one controller. To provision a controller on Windows 10, run the following on a preferrably fresh install of a fully updated Windows 10 Enterprise:

```console
powershell "(IEX(New-Object Net.WebClient).downloadString('https://bit.ly/AnsibleController'))"
```

Then, with Ubuntu installed, log into the Ubuntu WSL instance and finish the
installation of Ansible:

```console
wsl --set-version 'Ubuntu' 2
ubuntu
wget https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/controller.sh
&& bash controller.sh && rm controller.sh
```

The bit.ly links to [controller.ps1](https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/controller.ps1).

### Windows 10 Client

A client is a computer you wish to control with the controller. Windows needs to
have Remote Execution (RE) enabled. Run the following command in an
Administrator Powershell:

```console
powershell "(IEX(New-Object Net.WebClient).downloadString('https://bit.ly/AnsibleClient_'))"
```

The bit.ly links to [client.ps1](https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/client.ps1).

### Windows Notes

On Windows 10 Enterprise with Ubuntu WSL 2, UFW does not work without error.

### Useful Windows Commands

The following commands are PowerShell commands used for generating configurations.

- Export the start menu configuration:
  - `Export-StartLayout -path file_name.xml`
- Import start menu layout:
  - `Import-StartLayout -LayoutPath C:\layout.xml -MountPath %systemdrive%`
- List all of the installed apps AppIDs:
  - `get-StartApps`
- List all of the installed APPX files:
  - `Get-AppxPackage -AllUsers | Select Name, PackageFullName`
- List all of the available optional features:
  - `Get-WindowsOptionalFeature -Online`

## Mac OS X

### Mac OS X Notes

On Mac OS X, run `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` before running
an ansible-playbook when connecting to Parallels Windows.
