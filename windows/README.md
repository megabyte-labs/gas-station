# Windows 10 Playbooks

## Initial Setup Required

Run the following commands as an Administrator in Powershell on the target Windows 10 machines:

```
ConfigureRemotingForAnsible.ps1 -EnableCredSSP
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