#Requires -RunAsAdministrator

# @file scripts/quickstart.ps1
# @brief This script will help you easily take care of the requirements and then run [Gas Station](https://github.com/megabyte-labs/gas-station)
#   on your Windows computer.
# @description
#   1. This script will enable Windows features required for WSL.
#   2. It will reboot and continue where it left off.
#   3. Ensures Windows WinRM is active so the Ubuntu WSL environment can provision the Windows host.
#   4. Installs and pre-configures the WSL environment.
#   5. Ensures Docker Desktop is installed
#   6. Reboots and continues where it left off.
#   7. The playbook is run.

# Uncomment this to provision with WSL instead of Docker
# $ProvisionWithWSL = true
$QuickstartScript = "C:\Temp\quickstart.ps1"
# Change this to modify the password that the user account resets to
$UserPassword = 'MegabyteLabs'

New-Item -ItemType Directory -Force -Path C:\Temp
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# @description Reboot and continue script after reboot
function RebootAndContinue {
  if (!(Test-Path $QuickstartScript)) {
    Write-Host "Ensuring the recursive update script is downloaded"
    Start-BitsTransfer -Source "https://install.doctor/windows-quickstart" -Destination $QuickstartScript -Description "Downloading initialization script"
  }
  Write-Host "Ensuring start-up script is present" -ForegroundColor Black -BackgroundColor Cyan
  Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Gas Station.bat" "PowerShell.exe -ExecutionPolicy RemoteSigned -Command `"Start-Process -FilePath powershell -ArgumentList '-File C:\Temp\quickstart.ps1 -Verbose' -verb runas`""
  Write-Host "Changing $env:Username password to '$UserPassword' so we can automatically log back in" -ForegroundColor Black -BackgroundColor Cyan
  $NewPassword = ConvertTo-SecureString "$UserPassword" -AsPlainText -Force
  Set-LocalUser -Name $env:Username -Password $NewPassword
  Write-Host "Turning on auto-logon" -ForegroundColor Black -BackgroundColor Cyan
  $RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
  Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String
  Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$env:Username" -type String
  Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "MegabyteLabs" -type String
  Restart-Computer -Force
}

# @description Reboot and continue script after reboot (if required)
function RebootAndContinueIfRequired {
  if (!(Get-Module "PendingReboot")) {
    Write-Host "Installing PendingReboot module" -ForegroundColor Black -BackgroundColor Cyan
    Install-Module -Name PendingReboot -Force
  }
  Import-Module PendingReboot -Force
  if ((Test-PendingReboot).IsRebootPending) {
    RebootAndContinue
  }
}

# @description Ensure all Windows updates have been applied and then starts the provisioning process
function EnsureWindowsUpdated {
    if (!(Get-Module "PSWindowsUpdate")) {
      Write-Host "Installing update module" -ForegroundColor Black -BackgroundColor Cyan
      Install-Module -Name PSWindowsUpdate -Force
    }
    Write-Host "Ensuring all the available Windows updates have been applied." -ForegroundColor Black -BackgroundColor Cyan
    Import-Module PSWindowsUpdate -Force
    Get-WUInstall -AcceptAll -IgnoreReboot
    Write-Host "Checking if reboot is required." -ForegroundColor Black -BackgroundColor Cyan
    RebootAndContinueIfRequired
}

# @description Ensures Microsoft-Windows-Subsystem-Linux feature is available
function EnsureLinuxSubsystemEnabled {
    $wslenabled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-Object -Property State
    if ($wslenabled.State -eq "Disabled") {
        Write-Host "Enabling Microsoft-Windows-Subsystem-Linux" -ForegroundColor Black -BackgroundColor Cyan
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    }
}

# @description Ensure VirtualMachinePlatform feature is available
function EnsureVirtualMachinePlatformEnabled {
    $vmenabled = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform | Select-Object -Property State
    if ($vmenabled.State -eq "Disabled") {
        Write-Host "Enabling VirtualMachinePlatform" -ForegroundColor Black -BackgroundColor Cyan
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    }
}

# @description Ensures Ubuntu 22.04 is installed on the system from a .appx file
function EnsureUbuntuAPPXInstalled {
    if(!(Test-Path "C:\Temp\UBUNTU2204.appx")) {
        Write-Host "Downloading Ubuntu APPX" -ForegroundColor Black -BackgroundColor Cyan
        Start-BitsTransfer -Source "https://aka.ms/wslubuntu2204" -Destination "C:\Temp\UBUNTU2204.appx" -Description "Downloading Ubuntu 22.04 WSL image"
    }
    # TODO: Ensure this is the appropriate AppxPackage name
    $Ubuntu2204APPXInstalled = Get-AppxPackage -Name CanonicalGroupLimited.Ubuntu22.04onWindows
    if (!$Ubuntu2204APPXInstalled) {
        Write-Host "Adding Ubuntu APPX" -ForegroundColor Black -BackgroundColor Cyan
        Add-AppxPackage -Path "C:\Temp\UBUNTU2204.appx"
    }
}

# @description Automates the process of setting up the Ubuntu 22.04 WSL environment
function SetupUbuntuWSL {
    if ($ProvisionWithWSL) {
      Write-Host "Set default WSL version to 1 (required for bridged eth0 adapter)" -ForegroundColor Black -BackgroundColor Cyan
      wsl --set-default-version 1
    }
    Write-Host "Setting up Ubuntu WSL" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "install --root" -Wait -NoNewWindow
    $username = $env:Username.ToLower()
    Write-Host "Adding a user" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run adduser $username --gecos 'First,Last,RoomNumber,WorkPhone,HomePhone' --disabled-password" -Wait -NoNewWindow
    Write-Host "Adding user to sudo group" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run usermod -aG sudo $username" -Wait -NoNewWindow
    Write-Host "Enabling passwordless sudo privileges" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run echo '$username ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers" -Wait -NoNewWindow
    Write-Host "Setting default user" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "config --default-user $username" -Wait -NoNewWindow
}

# @description Ensures Docker Desktop is installed (which requires a reboot)
function EnsureDockerDesktopInstalled {
    if (!(Test-Path "C:\Program Files\Docker\Docker\Docker Desktop.exe")) {
      Write-Host "Installing Docker Desktop for Windows" -ForegroundColor Black -BackgroundColor Cyan
      choco install -y docker-desktop
      RebootAndContinue
    }
}

# @description Enables WinRM connectivity
function EnableWinRM {
  Write-Host "Enabling WinRM.." -ForegroundColor Black -BackgroundColor Cyan
  $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
  $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
  (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
  powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth -ForceNewSSLCert -SkipNetworkProfileCheck
  choco install -y -r openssl
  $UsernameLowercase = $env:Username.ToLower()
  $env:OpenSSLConfig = "C:\Temp\openssl.conf"
  Set-Content -Path $env:OpenSSLConfig -Value @"
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$UsernameLowercase@localhost
"@
  $UserPEMPath = Join-Path "C:\Temp" user.pem
  $KeyPEMPath = Join-Path "C:\Temp" key.pem
  & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" req -x509 -nodes -days 365 -newkey rsa:2048 -out $UserPEMPath -outform PEM -keyout $KeyPEMPath -subj "/CN=$UsernameLowercase" -extensions v3_req_client 2>&1
  Remove-Item $env:OpenSSLConfig -Force
  Import-Certificate -FilePath $UserPEMPath -CertStoreLocation cert:\LocalMachine\root
  $WinRMCert = Import-Certificate -FilePath $UserPEMPath -CertStoreLocation cert:\LocalMachine\TrustedPeople
  $PasswordCred = ConvertTo-SecureString -AsPlainText -Force $UserPassword
  $WinRMCreds = New-Object System.Management.Automation.PSCredential($UsernameLowercase, $PasswordCred) -ea Stop
  New-Item -Path WSMan:\localhost\ClientCertificate -Subject "$UsernameLowercase@localhost" -URI * -Issuer $WinRMCert.Thumbprint -Credential $WinRMCreds -Force
  Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
  Restart-Service -Name WinRM -Force
}

# @description Run the playbook with Docker
function RunPlaybookDocker {
  Set-Location -Path "C:\Temp"
  $CurrentLocation = Get-Location
  $WorkDirectory = Split-Path -leaf -path (Get-Location)
  $HostIP = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
  docker run -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) --name provisioner --add-host='windows:'$HostIP --entrypoint /bin/bash debian:buster-slim ./quickstart.sh
}

# @description Run the playbook with WSL
function RunPlaybookWSL {
    Write-Host "Running quickstart.sh in WSL environment" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh && bash quickstart.sh" -Wait -NoNewWindow
    Write-Host "Running quickstart continue command in WSL environment" -ForegroundColor Black -BackgroundColor Cyan
    Start-Process "ubuntu.exe" -ArgumentList "run cd ~/Playbooks && task ansible:quickstart" -Wait -NoNewWindow
}

# @description Install Chocolatey
function InstallChocolatey {
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# @description The main logic for the script - enable Windows features, set up Ubuntu WSL, and install Docker Desktop
# while continuing script after a restart.
function ProvisionWindowsWSLAnsible {
    if (!(Get-PackageProvider -Name "NuGet")) {
      Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    }
    EnsureWindowsUpdated
    EnableWinRM
    EnsureLinuxSubsystemEnabled
    EnsureVirtualMachinePlatformEnabled
    EnsureUbuntuAPPXInstalled
    SetupUbuntuWSL
    InstallChocolatey
    EnsureDockerDesktopInstalled
    if ($ProvisionWithWSL) {
      RunPlaybookWSL
    } else {
      RunPlaybookDocker
    }
    Write-Host "All done! Make sure you change your password. It was set to 'MegabyteLabs' for automation purposes." -ForegroundColor Black -BackgroundColor Cyan
    Read-Host "Press ENTER to exit, remove temporary files, and the start-up script"
    Remove-Item -path "C:\Temp" -Recurse -Force
    Remove-Item -path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Gas Station.bat" -Force
}

ProvisionWindowsWSLAnsible
