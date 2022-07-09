#Requires -RunAsAdministrator

# @file scripts/enable-winrm.ps1
# @brief Enables WinRM on a Windows machine
# @description
#   Runs the ConfigureRemotingForAnsible.ps1 script with the EnableCredSSP option. It also
#   ensures BasicAuth is disabled. After running this script, you should be able to connect to the
#   Windows instance from a WSL1 environment. WSL2 environments do not have access to the LAN
#   IP address so a WSL1 environment is preferred.

$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth
