Write-Host "Enabling the Microsoft Windows Subsystem Linux feature" -ForegroundColor DarkGreen -BackgroundColor White
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All
Write-Host "Downloading the script used to enable Ansible management" -ForegroundColor DarkGreen -BackgroundColor White
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Write-Host "Running the Ansible management script" -ForegroundColor DarkGreen -BackgroundColor White
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth
Write-Host "Downloading/setting up a script that will continue the installation after reboot" -ForegroundColor DarkGreen -BackgroundColor White
$nextRunUrl = "https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/windows-ubuntu-setup.ps1"
$nextRunFile = "C:\professor-manhattan-windows-ubuntu-setup.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($nextRunUrl, $nextRunFile)
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:24
Register-ScheduledJob -Trigger $trigger -FilePath $nextRunFile -Name ProfessorManhattanPlaybookUbuntuSetup
Write-Host "WSL and Windows RE are now enabled. Now, you have to download Ubuntu from the app store by following the instructions below." -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "1. Open the Microsoft Windows Store app from the Start Menu" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "2. Search for Ubuntu" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "1. Open the Microsoft Windows Store app from the Start Menu" -ForegroundColor DarkGreen -BackgroundColor White
Write-Host "1. Open the Microsoft Windows Store app from the Start Menu" -ForegroundColor DarkGreen -BackgroundColor White
echo "WSL and Windows RE are now enabled. Now, you have to download Ubuntu from the app store."
echo "1. Navigate to the Ubuntu app in the Windows App Store (https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6)"
echo "2. Install it"
echo "3. Reboot and this script will automatically continue"