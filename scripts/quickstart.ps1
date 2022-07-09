#Requires -RunAsAdministrator

# Run this file to automatically run the playbook on a Windows host / Windows WSL environment by leveraging
# WSL 1 to run Ansible and provision the Windows host along with the WSL environment.

New-Item -ItemType Directory -Force -Path C:\Temp
$rebootrequired = 0

# @description Ensure Microsoft-Windows-Subsystem-Linux is enabled
$wslenabled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-Object -Property State
if ($wslenabled.State -eq "Disabled") {
    Write-Host "Enabling Microsoft-Windows-Subsystem-Linux.." -ForegroundColor Black -BackgroundColor Cyan
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    $rebootrequired = 1
}
else {
    Write-Host "Microsoft-Windows-Subsystem-Linux (i.e. WSL) is already enabled." -ForegroundColor Black -BackgroundColor Cyan
}

# @description Ensure VirtualMachinePlatform is enabled
$vmenabled = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform | Select-Object -Property State
if ($vmenabled.State -eq "Disabled") {
    Write-Host "Enabling VirtualMachinePlatform.." -ForegroundColor Black -BackgroundColor Cyan
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    $rebootrequired = 1
}
else {
    Write-Host "VirtualMachinePlatform is already enabled." -ForegroundColor Black -BackgroundColor Cyan
}

# @description Define workflow that continues the script if a reboot is required
workflow Resume_Workflow {
    # Restart if required
    if ($rebootrequired -eq 1) {
        Write-Host ""
        Write-Host "============================================" -ForegroundColor Yellow -BackgroundColor DarkGreen
        Write-Host "Rebooting in 10s..  " -ForegroundColor Yellow -BackgroundColor DarkGreen
        Write-Host "============================================" -ForegroundColor Yellow -BackgroundColor DarkGreen
        Start-Sleep -s 10
        Restart-Computer -Wait
    }

    # @description Ensure WSL 1 is used because it is easier to provision the Windows host with WSL 1 networking
    wsl --set-default-version 1

    # @description Ensure the Linux kernel is up-to-date
    if (!(Test-Path "C:\Temp\wsl_update_x64.msi")) {
        Write-Host "Downloading the Linux kernel update package.." -ForegroundColor Black -BackgroundColor Cyan
        Start-BitsTransfer -Source "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -Destination "C:\Temp\wsl_update_x64.msi" -Description "Downloading the Linux kernel update package.."
    }
    else {
        Write-Host "The Linux kernel update package is already available." -ForegroundColor Black -BackgroundColor Cyan
    }
    Write-Host "Installing the Linux kernel update package.." -ForegroundColor Black -BackgroundColor Cyan
    Start-Process 'msiexec' -ArgumentList '/quiet /i C:\Temp\wsl_update_x64.msi' -Wait -NoNewWindow

    # @description Ensure the Ubuntu 20.04 WSL image is available
    if (!(Test-Path "C:\Temp\UBUNTU2004.appx")) {
        Write-Host "Downloading the Ubuntu 20.04 image. Please wait.." -ForegroundColor Black -BackgroundColor Cyan
        Start-BitsTransfer -Source "https://aka.ms/wslubuntu2004" -Destination "C:\Temp\UBUNTU2004.appx" -Description "Downloading the Ubuntu 20.04 WSL image.."
    }
    else {
        Write-Host "The Ubuntu 20.04 image is already available at C:\Temp\UBUNTU2004.appx." -ForegroundColor Black -BackgroundColor Cyan
    }

    # @description Ensure the Ubuntu 20.04 WSL environment is installed / available
    $ubu2004appxinstalled = Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu20.04onWindows
    if ($ubu2004appxinstalled) {
        Write-Host "Ubuntu 20.04 appx is already installed." -ForegroundColor Black -BackgroundColor Cyan
    }
    else {
        Write-Host "Installing the Ubuntu 20.04 WSL environment.." -ForegroundColor Black -BackgroundColor Cyan
        Add-AppxPackage -Path "C:\Temp\UBUNTU2004.appx"
    }

    # @description Configure the environment
    Write-Host "Configuring WSL Ubuntu 20.04" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "install --root" -Wait -NoNewWindow
    Write-Host "Set /c/ as mount point"
    Start-Process "ubuntu.exe" -ArgumentList "run echo '[automount]' > /etc/wsl.conf" -Wait -NoNewWindow
    Start-Process "ubuntu.exe" -ArgumentList "run echo 'root = /' >> /etc/wsl.conf" -Wait -NoNewWindow
    Restart-Service LxssManager
    Start-Sleep -s 5

    # @description Prompt for the WSL environment username and then configure the environment with it
    $username = Read-Host -Prompt 'Enter a username for the WSL environment:'
    Write-Host "Creating the $username user" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run adduser $username --gecos 'First,Last,RoomNumber,WorkPhone,HomePhone' --disabled-password" -Wait    -NoNewWindow
    Write-Host "Adding $username to sudo group" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run usermod -aG sudo $username" -Wait -NoNewWindow
    Write-Host "Granting $username access to passwordless sudo privileges" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run echo '$username ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers" -Wait -NoNewWindow
    # Write-Host "Ask for $username password to set" -ForegroundColor Black -BackgroundColor Cyan
    # Start-Process "ubuntu.exe" -ArgumentList "run passwd $username" -Wait -NoNewWindow
    Write-Host "Set WSL default user to $username" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "config --default-user $username" -Wait -NoNewWindow
    Write-Host "Update Ubuntu 20.04 and install some packages" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "WSL" -ArgumentList "bash preparewsl2.sh" -Wait -NoNewWindow

    # @description Ensure Docker Desktop is installed on the Windows host - commented out since we are using WSL 1
    Write-Host "Installing Docker Desktop" -ForegroundColor Black -BackgroundColor Cyan
    if (!(Test-Path "C:\Temp\docker-desktop-installer.exe")) {
        Write-Host "Downloading the Docker Desktop installer." -ForegroundColor Black -BackgroundColor Cyan
        Start-BitsTransfer -Source "https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe" -Destination "C:\Temp\docker-desktop-installer.exe" -Description "Downloading Docker Desktop"
    }
    Start-Process 'C:\Temp\docker-desktop-installer.exe' -ArgumentList 'install --quiet' -Wait -NoNewWindow
    # When Docker Desktop detects WSL2, it automatically installs Docker client in there.
    Write-Host "Waiting for Docker Desktop to start" -ForegroundColor Black -BackgroundColor Cyan
    & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    Start-Sleep -s 30

    # @description Run the automated Ansible playbook provisioning
    Write-Host "Downloading the quickstart.sh file" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh" -Wait -NoNewWindow
    Start-Process "ubuntu.exe" -ArgumentList "run sudo apt-get update && sudo apt-get upgrade -y && bash quickstart.sh" -Wait -NoNewWindow
}

# @description Set up workflow so that the script can continue even if a restart is necessary
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
$AtStartup = New-JobTrigger -AtStartup
Register-ScheduledJob -Name Resume_Workflow_Job -Trigger $AtStartup -ScriptBlock ({ [System.Management.Automation.Remoting.PSSessionConfigurationData]::IsServerManager = $true; Import-Module PSWorkflow; Resume-Job -Name new_resume_workflow_job -Wait }) -ScheduledJobOption $options

# @description Resume script as the Resume_Workflow workflow
Resume_Workflow -AsJob -JobName new_resume_workflow_job
