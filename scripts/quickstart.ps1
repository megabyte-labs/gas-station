#Requires -RunAsAdministrator

# @file scripts/quickstart.ps1
# @brief This script will help you easily take care of the requirements and then run [Gas Station](https://github.com/megabyte-labs/gas-station)
#   on your Windows computer.
# @description
#   1. This script will enable Windows features required for WSL.
#   2. It will reboot and continue where it left off.
#   3. Installs and pre-configures the WSL environment.
#   4. Ensures Docker Desktop is installed
#   5. Reboots and continues where it left off.
#   6. Ensures Windows WinRM is active so the Ubuntu WSL environment can provision the Windows host.
#   7. The playbook is run.

New-Item -ItemType Directory -Force -Path C:\Temp
$rebootrequired=0

# @description Ensures Microsoft-Windows-Subsystem-Linux feature is available
function EnsureLinuxSubsystemEnabled {
    $wslenabled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-Object -Property State
    if ($wslenabled.State -eq "Disabled") {
        Write-Host "WSL is not enabled. Enabling now." -ForegroundColor Yellow -BackgroundColor DarkGreen
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        $rebootrequired = 1
    } else {
        Write-Host "WSL already enabled. Moving on." -ForegroundColor Yellow -BackgroundColor DarkGreen
    }
}

# @description Ensure VirtualMachinePlatform feature is available
function EnsureVirtualMachinePlatformEnabled {
    $vmenabled = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform | Select-Object -Property State
    if ($vmenabled.State -eq "Disabled") {
        Write-Host "VirtualMachinePlatform is not enabled.  Enabling now." -ForegroundColor Yellow -BackgroundColor DarkGreen
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
        $rebootrequired=1
    } else {
        Write-Host "VirtualMachinePlatform already enabled. Moving on." -ForegroundColor Yellow -BackgroundColor DarkGreen
    }
}

# @description Ensures Ubuntu 20.04 is installed on the system from a .appx file
function EnsureUbuntuAPPXInstalled {
    if(!(Test-Path "C:\Temp\UBUNTU2004.appx")) {
        Write-Host "Downloading the Ubuntu 20.04 image. Please wait." -ForegroundColor Yellow -BackgroundColor DarkGreen
        Start-BitsTransfer -Source "https://aka.ms/wslubuntu2004" -Destination "C:\Temp\UBUNTU2004.appx" -Description "Downloading Ubuntu 20.04 WSL image"
    } else {
        Write-Host "The Ubuntu 20.04 image was already at C:\Temp\UBUNTU2004.appx. Moving on." -ForegroundColor Yellow -BackgroundColor DarkGreen
    }
    $ubu2004appxinstalled = Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu20.04onWindows
    if ($ubu2004appxinstalled) {
        Write-Host "Ubuntu 20.04 appx is already installed. Moving on." -ForegroundColor Yellow -BackgroundColor DarkGreen
    } else {
        Write-Host "Installing the Ubuntu 20.04 Appx distro. Please wait." -ForegroundColor Yellow -BackgroundColor DarkGreen
        Add-AppxPackage -Path "C:\Temp\UBUNTU2004.appx"
    }
}

# @description Automates the process of setting up the Ubuntu 20.04 WSL environment
function SetupUbuntuWSL {
    Write-Host "Configuring Ubuntu 20.04 WSL.." -ForegroundColor Yellow -BackgroundColor DarkGreen
    Start-Process "ubuntu.exe" -ArgumentList "install --root" -Wait -NoNewWindow
    $username = Read-Host -Prompt 'Enter a username for the WSL environment'
    Write-Host "Creating the $username user.." -ForegroundColor Yellow -BackgroundColor DarkGreen
    Start-Process "ubuntu.exe" -ArgumentList "run adduser $username --gecos 'First,Last,RoomNumber,WorkPhone,HomePhone' --disabled-password" -Wait -NoNewWindow
    Write-Host "Adding $username to sudo group" -ForegroundColor Yellow -BackgroundColor DarkGreen
    Start-Process "ubuntu.exe" -ArgumentList "run usermod -aG sudo $username" -Wait -NoNewWindow
    Write-Host "Allowing $username to run sudo without a password" -ForegroundColor Yellow -BackgroundColor DarkGreen
    Start-Process "ubuntu.exe" -ArgumentList "run echo '$username ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers" -Wait -NoNewWindow
    Write-Host "Set WSL default user to $username" -ForegroundColor Yellow -BackgroundColor DarkGreen
    Start-Process "ubuntu.exe" -ArgumentList "config --default-user $username" -Wait -NoNewWindow
}

# @description Ensures Docker Desktop is installed (which requires a reboot)
function EnsureDockerDesktopInstalled {
    Write-Host "Installing Docker Desktop" -ForegroundColor Yellow -BackgroundColor DarkGreen
    if (!(Test-Path "C:\Temp\docker-desktop-installer.exe")) {
        Write-Host "Downloading the Docker Desktop installer." -ForegroundColor Yellow -BackgroundColor DarkGreen
        Start-BitsTransfer -Source "https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -Destination "C:\Temp\docker-desktop-installer.exe" -Description "Downloading Docker Desktop"
    }
    Start-Process 'C:\Temp\docker-desktop-installer.exe' -ArgumentList 'install --quiet' -Wait -NoNewWindow
    Write-Host "Waiting for Docker Desktop to start" -ForegroundColor Yellow -BackgroundColor DarkGreen
    & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    Start-Sleep -s 30
    Write-Host "Done. Rebooting again.." -ForegroundColor Yellow -BackgroundColor DarkGreen
}

# @description Enables WinRM connectivity
function EnableWinRM {
    $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
    $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
    powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth
}

# @description Run the playbook
function RunPlaybook {
    Start-Process "WSL" -ArgumentList "curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh && bash quickstart.sh" -Wait -NoNewWindow
}

# @description The main logic for the script - enable Windows features, set up Ubuntu WSL, and install Docker Desktop
# while continuing script after a restart.
workflow ProvisionWindowsWSLAnsible {
    EnsureLinuxSubsystemEnabled
    EnsureVirtualMachinePlatformEnabled
    if ($rebootrequired -eq 1) {
        Restart-Computer -Wait
    }
    EnsureUbuntuAPPXInstalled
    SetupUbuntuWSL
    EnsureDockerDesktopInstalled
    Restart-Computer -Wait
    EnableWinRM
    RunPlaybook
}

# @description Run the PowerShell workflow job that spans across reboots
$PSPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Args = '-Command "& {Import-Module PSWorkflow ; Get-Job | Resume-Job}"'
$Action = New-ScheduledTaskAction -Execute $PSPath -Argument $Args
$Option = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -WakeToRun
$Trigger = New-JobTrigger -AtStartUp -RandomDelay (New-TimeSpan -Minutes 5)
Register-ScheduledTask -TaskName ResumeJob -Action $Action -Trigger $Trigger -Settings $Option -RunLevel Highest
ProvisionWindowsWSLAnsible -AsJob

