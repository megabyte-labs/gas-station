## Setting Up Development Environment

Before contributing to this project, you will have to make sure you have the tools that are utilized. The following is required for developing and testing this Ansible project:

### Requirements

* **Ansible** >=2.10
* **Python 3**, along with the `python3-netaddr` and `python3-pip` libraries (i.e. `sudo apt-get install python3 python3-netaddr python3-pip`)
* **Docker**
* **Node.js** >=12 which is used for the development environment which includes a pre-commit hook
* **VirtualBox** which is used for running Molecule tests

### Getting Started

With all the requirements installed, navigate to the root directory and run the following commands to set up the development environment which includes installing the Python dependencies and installing the Ansible Galaxy dependencies:

```terminal
npm i
```

This will install all the dependencies and automatically register a pre-commit hook. More specifically, `npm i` will:

1. Install the Node.js development environment dependencies
2. Install a pre-commit hook using [husky](https://www.npmjs.com/package/husky)
3. Ensure that meta files and documentation are up-to-date
4. Install the Python 3 requirements
5. Install the Ansible Galaxy requirements

### NPM Tasks Available

With the dependencies installed, you can see a list of the available commands by running `npm run info`. This will log a help menu to the console informing you about the available commands and what they do. After running the command, you will see something that looks like this:

```shell
❯ npm run info

> ansible-project@1.0.0 info
> npm-scripts-info

commit:
  IMPORTANT: Whenever committing code run 'git-cz' or 'npm run commit'
fix:
  Automatically fix formatting errors
info:
  Displays descriptions of all the npm tasks
lint:
  Report linting errors
prepare-release:
  Prepares the repository for a release
test:
  Runs molecule tests for all the supported operating systems (this is RAM intensive)
test:docker:
  Runs molecule tests using Docker
test:local:
  Installs the role on your local machine
test:archlinux:
  Provisions an Archlinux Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:centos:
  Provisions a CentOS Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:debian:
  Provisions a Debian Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:fedora:
  Provisions a Fedora Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:macosx:
  Provisions a Mac OS X VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:ubuntu:
  Provisions a Ubuntu Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
test:windows:
  Provisions a Windows Desktop VirtualBox VM, installs the role(s), and does not delete the VM after testing
update:
  Runs .update.sh to automatically update meta files, documentation, and dependencies
version:
  Used by 'npm run prepare-release' to update the CHANGELOG
```

Using the information provided above by running `npm run info`, we can see that `npm run build` will run the `build` step described above. You can see exactly what each command is doing by checking out the `package.json` file.

### Troubleshooting Python Issues

If you are experiencing issues with the Python modules, you can make use of `venv` by running the following before running the above commands:

```terminal
python3 -m venv venv
source venv/bin/activate
```
