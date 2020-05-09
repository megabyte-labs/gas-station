Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux" -All
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth
$nextRunUrl = "https://gitlab.com/ProfessorManhattan/Playbooks/-/raw/master/files/windows/windows-ubuntu-setup.ps1"
$nextRunFile = "C:\temp\windows-ubuntu-setup.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($nextRunUrl, $nextRunFile)
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:24
Register-ScheduledJob -Trigger $trigger -FilePath $nextRunFile -Name ProfessorManhattanPlaybookUbuntuSetup
echo "WSL and Windows RE are now enabled. Now, you have to download Ubuntu from the app store."
echo "1. Open the Microsoft Windows Store app"
echo "2. Search for Ubuntu"
echo "3. Install it"
echo "4. Reboot and this script will automatically continue"