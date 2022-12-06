## Quick Start

The easiest way to run the entire playbook, outlined in the `main.yml` file, is to run the appropriate command listed below. These commands will run the playbook on the machine you run the command on. This is probably the best way to get your feet wet before you decide to give us a ⭐ and customize the playbook for your own needs. Ideally, this command should be run on the machine that you plan on running Ansible with to provision the other computers on your network. It is only guaranteed to work on fresh installs so testing it out with [Vagrant](https://www.vagrantup.com/) is highly encouraged.

### Vagrant (Recommended)

To test it out with Vagrant, you can run the following commands which will open up an interactive dialog where you can pick which operating system and virtualization provider you wish to test the installation with:

```shell
bash .config/scripts/start.sh # Only required if you do not have the dependencies (i.e. Task) already installed
task ansible:test:vagrant
```

### macOS/Linux

```shell
curl -sS https://gitlab.com/megabyte-labs/gas-station/-/raw/master/files/quickstart.sh | bash
```

### Windows

In an administrative PowerShell session, run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://gitlab.com/megabyte-labs/gas-station/-/raw/master/files/quickstart.ps1'))
```
