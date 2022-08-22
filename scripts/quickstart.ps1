#Requires -RunAsAdministrator

# @file scripts/quickstart.ps1
# @brief This script will help you easily take care of the requirements and then run [Gas Station](https://github.com/megabyte-labs/gas-station)
#   on your Windows computer.
# @description
#   1. This script will enable Windows features required for WSL.
#   2. It will reboot and continue where it left off.
#   3. Ensures Windows WinRM is active and configured.
#   4. Installs and pre-configures the WSL environment.
#   5. Ensures Docker Desktop is installed
#   6. Reboots and continues where it left off.
#   7. The playbook is run.

# Uncomment this to provision with WSL instead of Docker
# $ProvisionWithWSL = 'True'
$QuickstartScript = "C:\Temp\quickstart.ps1"
$QuickstartShellScript = "C:\Temp\quickstart.sh"
# Change this to modify the password that the user account resets to
$UserPassword = 'MegabyteLabs'

New-Item -ItemType Directory -Force -Path C:\Temp
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# @description Prepares the machine to automatically continue installation after a reboot
function PrepareForReboot {
  if (!(Test-Path $QuickstartScript)) {
    Write-Host "Ensuring the recursive update script is downloaded" -ForegroundColor Black -BackgroundColor Cyan
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
}

# @description Reboot and continue script after reboot
function RebootAndContinue {
  PrepareForReboot
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
  Write-Host "Setting up Ubuntu WSL" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "install --root" -Wait -NoNewWindow
  $UsernameLowercase = $env:Username.ToLower()
  Write-Host "Adding a user" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "run adduser $UsernameLowercase --gecos 'First,Last,RoomNumber,WorkPhone,HomePhone' --disabled-password" -Wait -NoNewWindow
  Write-Host "Adding user to sudo group" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "run usermod -aG sudo $UsernameLowercase" -Wait -NoNewWindow
  Write-Host "Enabling passwordless sudo privileges" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "run echo '$UsernameLowercase ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers" -Wait -NoNewWindow
  Write-Host "Setting default user" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "config --default-user $UsernameLowercase" -Wait -NoNewWindow
}

# @description Ensures Docker Desktop is installed (which requires a reboot)
function EnsureDockerDesktopInstalled {
  if (!(Test-Path "C:\Program Files\Docker\Docker\Docker Desktop.exe")) {
    Write-Host "Installing Docker Desktop for Windows" -ForegroundColor Black -BackgroundColor Cyan
    choco install -y docker-desktop
    Write-Host "Ensuring WSL version is set to 2 (required for Docker Desktop)" -ForegroundColor Black -BackgroundColor Cyan
    wsl --set-default-version 2
    RebootAndContinue
  }
}

# @description Attempts to run a minimal Docker container and instructs the user what to do if it is not working
function EnsureDockerFunctional {
  Write-Host "Ensuring WSL version is set to 2 (required for Docker Desktop)" -ForegroundColor Black -BackgroundColor Cyan
  wsl --set-default-version 2
  Write-Host "Running test command (i.e. docker run hello-world)" -ForegroundColor Black -BackgroundColor Cyan
  docker run hello-world
  if ($?) {
    Write-Host "Docker Desktop is operational! Continuing.." -ForegroundColor Black -BackgroundColor Cyan
  } else {
    Write-Host "Updating WSL's kernel" -ForegroundColor Black -BackgroundColor Cyan
    wsl --update
    Write-Host "Shutting down / rebooting WSL" -ForegroundColor Black -BackgroundColor Cyan
    wsl --shutdown
    & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    Write-Host "Waiting for Docker Desktop to come online" -ForegroundColor Black -BackgroundColor Cyan
    Start-Sleep -s 30
    docker run hello-world
    if ($?) {
      Write-Host "Docker is now running and operational! Continuing.." -ForegroundColor Black -BackgroundColor Cyan
    } else {
      Write-Host "**************"
      Write-Host "Docker Desktop does not appear to be functional yet. If you used this script, Docker Desktop should load on boot. Follow these instructions:" -ForegroundColor Black -BackgroundColor Cyan
      Write-Host "1. Open Docker Desktop if it did not open automatically and accept the agreement if one is presented." -ForegroundColor Black -BackgroundColor Cyan
      Write-Host "2. If Docker Desktop opens a dialog that says WSL 2 installation is incomplete then click the Restart button." -ForegroundColor Black -BackgroundColor Cyan
      Write-Host "3. Press ENTER here to attempt to proceed." -ForegroundColor Black -BackgroundColor Cyan
      Write-Host "4. Optionally, configure Docker to start up on boot by going to Settings -> General." -ForegroundColor Black -BackgroundColor Cyan
      Write-Host "**************"
      Read-Host "Press ENTER to continue (after Docker Desktop stops displaying warning modals)"
      EnsureDockerFunctional
    }
  }
}

# @description Enables WinRM connectivity
function EnableWinRM {
  # Download and run the Ansible WinRM script
  Write-Host "Enabling WinRM.." -ForegroundColor Black -BackgroundColor Cyan
  $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
  $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
  (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
  powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth -ForceNewSSLCert -SkipNetworkProfileCheck
  # Generate OpenSSL configuration and encryption keys
  Write-Host "Ensuring OpenSSL is installed" -ForegroundColor Black -BackgroundColor Cyan
  choco install -y -r openssl
  $UsernameLowercase = $env:Username.ToLower()
  $OpenSSLConfig = "C:\Temp\openssl.conf"
  Set-Content -Path $OpenSSLConfig -Value @"
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$UsernameLowercase@localhost
"@
  $UserPEMPath = Join-Path "C:\Temp" user.pem
  $KeyPEMPath = Join-Path "C:\Temp" key.pem
  Write-Host "Generating PEM files with OpenSSL" -ForegroundColor Black -BackgroundColor Cyan
  & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" req -x509 -nodes -days 365 -newkey rsa:2048 -out $UserPEMPath -outform PEM -keyout $KeyPEMPath -subj "/CN=$UsernameLowercase" -extensions v3_req_client 2>&1
  #Remove-Item $OpenSSLConfig -Force
  # Configure WinRM to use the generated configurations / credentials
  Write-Host "Importing PEM certificates" -ForegroundColor Black -BackgroundColor Cyan
  Import-Certificate -FilePath $UserPEMPath -CertStoreLocation cert:\LocalMachine\root
  $WinRMCert = Import-Certificate -FilePath $UserPEMPath -CertStoreLocation cert:\LocalMachine\TrustedPeople
  $PasswordCred = ConvertTo-SecureString -AsPlainText -Force $UserPassword
  $WinRMCreds = New-Object System.Management.Automation.PSCredential($UsernameLowercase, $PasswordCred) -ea Stop
  Write-Host "Configuring WinRM to use the certificates" -ForegroundColor Black -BackgroundColor Cyan
  New-Item -Path WSMan:\localhost\ClientCertificate -Subject "$UsernameLowercase@localhost" -URI * -Issuer $WinRMCert.Thumbprint -Credential $WinRMCreds -Force
  Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
  # Restart WinRM
  Write-Host "Restarting WinRM" -ForegroundColor Black -BackgroundColor Cyan
  Restart-Service -Name WinRM -Force
}

# @description Run the playbook with Docker
function RunPlaybookDocker {
  Set-Location -Path "C:\Temp"
  $CurrentLocation = Get-Location
  $WorkDirectory = Split-Path -leaf -path (Get-Location)
  if (!(Test-Path $QuickstartShellScript)) {
    Write-Host "Ensuring the quickstart shell script is downloaded" -ForegroundColor Black -BackgroundColor Cyan
    Start-BitsTransfer -Source "https://install.doctor/quickstart" -Destination $QuickstartShellScript -Description "Downloading initialization shell script"
  }
  Write-Host "Acquiring LAN IP address" -ForegroundColor Black -BackgroundColor Cyan
  $HostIPValue = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
  if ($HostIPValue -is [array]) {
    $HostIP = $HostIPValue[0]
  } else {
    $HostIP = $HostIPValue
  }
  PrepareForReboot
  Write-Host "Provisioning environment with Docker using $HostIP as the IP address" -ForegroundColor Black -BackgroundColor Cyan
  docker run -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) --add-host='windows:'$HostIP --entrypoint /bin/bash megabytelabs/updater:latest-full ./quickstart.sh
}

# @description Run the playbook with WSL
function RunPlaybookWSL {
  Write-Host "Running quickstart.sh in WSL environment" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "run curl -sSL https://gitlab.com/megabyte-labs/gas-station/-/raw/master/scripts/quickstart.sh > quickstart.sh && bash quickstart.sh" -Wait -NoNewWindow
  Write-Host "Running quickstart continue command in WSL environment" -ForegroundColor Black -BackgroundColor Cyan
  Start-Process "ubuntu.exe" -ArgumentList "run cd ~/Playbooks && source ~/.profile && task ansible:quickstart" -Wait -NoNewWindow
}

# @description Install Chocolatey
function InstallChocolatey {
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# @description The main logic for the script - enable Windows features, set up Ubuntu WSL, and install Docker Desktop
# while continuing script after a restart.
function ProvisionWindowsAnsible {
  Write-Host "Ensuring Windows is updated and that pre-requisites are installed.." -ForegroundColor Black -BackgroundColor Cyan
  if (!(Get-PackageProvider -Name "NuGet")) {
    Write-Host "Installing NuGet since the system is missing the required version.." -ForegroundColor Black -BackgroundColor Cyan
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
  }
  EnsureWindowsUpdated
  InstallChocolatey
  EnableWinRM
  EnsureLinuxSubsystemEnabled
  EnsureVirtualMachinePlatformEnabled
  EnsureDockerDesktopInstalled
  EnsureDockerFunctional
  if ($ProvisionWithWSL -eq 'true') {
    EnsureUbuntuAPPXInstalled
    SetupUbuntuWSL
    RunPlaybookWSL
  } else {
    RunPlaybookDocker
  }
  Write-Host "All done! Make sure you change your password. It was set to 'MegabyteLabs' for automation purposes." -ForegroundColor Black -BackgroundColor Cyan
  Read-Host "Press ENTER to exit, remove temporary files, and the start-up script"
  Remove-Item -path "C:\Temp" -Recurse -Force
  Remove-Item -path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Gas Station.bat" -Force
}

ProvisionWindowsAnsible
