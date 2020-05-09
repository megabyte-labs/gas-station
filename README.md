# Playbooks
On a fresh install of Windows 10 Enterprise, run the following command in an Administrator Powershell:

**Windows 10 controller:**
The controller is responsible for running Ansible to provision other parts of the system. There only needs to be one controller. To provision a controller, run the following on a preferrably fresh install of a fully updated Windows 10 Enterprise:
```
powershell "(IEX(New-Object Net.WebClient).downloadString('https://bit.ly/AnsibleController'))"
```
Then, with Ubuntu installed, log into the Ubuntu WSL instance and finish the installation of Ansible:
```
ubuntu
curl https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/controller.sh | bash
```

The bit.ly links to [https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/controller.ps1]().

**Windows 10 client:**

A client is a computer you wish to control with the controller. Windows needs to have Remote Execution (RE) enabled. Run the following command in an Administrator Powershell:

```
powershell "(IEX(New-Object Net.WebClient).downloadString('https://bit.ly/AnsibleClient_'))"
```

The bit.ly links to [https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/client.ps1']().

## Run the playbook

```
ansible-playbook --ask-vault-pass main.yml
```

## Gotchas

On Mac OS X, run `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` before running an ansible-playbook when connecting to Parallels Windows.

## Useful Commands

The following commands are Powershell commands used for generating configurations.

* Export the start menu configuration: `Export-StartLayout -path file_name.xml`
* Import start menu layout: `Import-StartLayout -LayoutPath C:\layout.xml -MountPath %systemdrive%`
* List all of the installed apps AppIDs: `get-StartApps`
* List all of the installed APPX files: `Get-AppxPackage -AllUsers | Select Name, PackageFullName`
* List all of the available optional features: `Get-WindowsOptionalFeature -Online`

## DISM

* dism /online /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All