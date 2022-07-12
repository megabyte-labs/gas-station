# This file should be used when you are provisioning the main Ansible controller if it is a Windows
# machine. The Ansible controller is the computer where you will provision other machines from. This
# file should only be used if your main computer that provisions other machines is a Windows machine.

Write-Host "Enabling the Microsoft Windows Subsystem Linux feature" -ForegroundColor Black -BackgroundColor Cyan
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All
Write-Host "Downloading the script used to enable Ansible management" -ForegroundColor Black -BackgroundColor Cyan
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Write-Host "Running the Ansible management script" -ForegroundColor Black -BackgroundColor Cyan
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth

# Write-Host "Downloading/setting up a script that will continue the installation after reboot" -ForegroundColor Black -BackgroundColor Cyan
# $nextRunUrl = "https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/windows-ubuntu-setup.ps1"
# $nextRunFile = "C:\professor-manhattan-windows-ubuntu-setup.ps1"
# (New-Object -TypeName System.Net.WebClient).DownloadFile($nextRunUrl, $nextRunFile)
# $TaskTrigger = (New-ScheduledTaskTrigger -atstartup)
# $TaskAction = New-ScheduledTaskAction -Execute Powershell.exe -argument "-ExecutionPolicy Bypass -File $nextRunFile"
# $TaskUserID = New-ScheduledTaskPrincipal -UserId System -RunLevel Highest -LogonType ServiceAccount
# Register-ScheduledTask -Force -TaskName HeadlessRestartTask -Action $TaskAction -Principal $TaskUserID -Trigger $TaskTrigger
Write-Host "WSL and Windows RE are now enabled. Now, you have to download Ubuntu from the app store by following the instructions below." -ForegroundColor Black -BackgroundColor Cyan
Write-Host "1. Navigate to the Ubuntu app in the Windows App Store (https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6) and also the Python app (https://www.microsoft.com/en-us/p/python-38/9mssztt1n39l)" -ForegroundColor Black -BackgroundColor Cyan
Write-Host "2. Install the app" -ForegroundColor Black -BackgroundColor Cyan
Write-Host "3. Reboot and this script will automatically continue" -ForegroundColor Black -BackgroundColor Cyan
