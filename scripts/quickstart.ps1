# This file should be used when you are provisioning the main Ansible controller if it is a Windows
# machine. The Ansible controller is the computer where you will provision other machines from. This
# file should only be used if your main computer that provisions other machines is a Windows machine.

Write-Host "Installing Ubuntu in WSL" -ForegroundColor Black -BackgroundColor Cyan
wsl --install -d Ubuntu

Write-Host "Downloading the script used to enable Ansible management" -ForegroundColor Black -BackgroundColor Cyan
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Write-Host "Running the Ansible management script" -ForegroundColor Black -BackgroundColor Cyan
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth

# -------------------------WinRM Alternative setup steps----------------------------------
# Start-Service WinRM
# winrm delete winrm/config/Listener?Address=*+Transport=HTTP

# $cert = New-SelfSignedCertificate -Subject "CN=$env:computerName" -TextExtension '2.5.29.37={text}1.3.6.1.5.5.7.3.1'

# winrm set winrm/config/service/auth @{Basic="true";Kerberos="false";Negotiate="true";Certificate="false";CredSSP="false"}
# New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{address="*";transport="https"} -ValueSet @{Hostname=$env:computerName;CertificateThumbprint=$cert.thumbprint}

# New-NetFirewallRule -DisplayName "WSL (HTTPS-In)" -Direction Inbound  -InterfaceAlias "vEthernet (WSL)"  -Action Allow -LocalPort 5986 -Protocol TCP
# ----------------------------------------------------------------------------------------

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

# Write the script that should be run on reboot to the filesystem
@"
# Wait till WSL is running before kicking off the playbook
`$res` = wsl -l -v | Out-String
while (`$res` -notmatch '.*r.u.n.n.i.n.g.*'){
  Write-Output "Waiting for WSL to start running..."
  Start-sleep 2
  `$res` = wsl -l -v | Out-String
}

Stop-Process -Name 'ubuntu' -ea SilentlyContinue

# TODO: Revisit this section to add the logic which will download and execute the script
# quickstart.sh, which clones/downloads the repository and executes the `task` ansible:quickstart

# Execute the quickstart script once WSL is running
# wsl cd ~/Playbooks; ./scripts/quickstart.sh

# Remove this script at the end of execution
Remove-Item (`$script:MyInvocation`).MyCommand.Path -Force
"@ | Out-File -FilePath C:\continue_after_reboot.ps1 -Encoding utf8

# The below commands set up a script to run on reboot
$KeyName = 'Continue'
$Command = '%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file C:\continue_after_reboot.ps1'
if (-not ((Get-Item -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce).$KeyName )){
  New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -PropertyType ExpandString
}else{
  Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $KeyName -Value $Command -PropertyType ExpandString
}

# Reboot
Restart-Computer
