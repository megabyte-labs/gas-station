# Enable Unified Write Filter
uwfmgr filter enable

# Protect the C drive
uwfmgr volume protect c:

# Preserve Windows Defender virus signatures
# https://docs.microsoft.com/en-us/windows-hardware/customize/enterprise/uwf-antimalware-support
uwfmgr file add-exclusion "$env:ALLUSERSPROFILE\Microsoft\Microsoft Antimalware"
uwfmgr file add-exclusion "$env:ALLUSERSPROFILE\Microsoft\Windows Defender"
uwfmgr file add-exclusion "$env:PROGRAMFILES\Microsoft Security Client"
uwfmgr file add-exclusion "$env:PROGRAMFILES\Windows Defender"
uwfmgr file add-exclusion "$env:WinDir\WindowsUpdate.log"
uwfmgr file add-exclusion "$env:WinDir\Temp\MpCmdRun.log"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Antimalware"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdBoot"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdFilter"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisSvc"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WdNisDrv"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WinDefend"

# Preserves Daylight Saving Time settings
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

# Preserves OneDrive and user files
uwfmgr file add-exclusion "$env:OneDrive"
uwfmgr file add-exclusion "$env:USERPROFILE\Downloads"
uwfmgr file add-exclusion "$env:USERPROFILE\Videos"
uwfmgr file add-exclusion "$env:USERPROFILE\AppData\Local\Google\Chrome"
# Recommended exclusions
# Source: https://www.10zig.com/resources/support_faq/unified-write-filter
uwfmgr file add-exclusion "$env:ALLUSERSPROFILE\Microsoft\Network\Downloader"
uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\BITS\StateIndex"

# Recommended exclusions
# Source: https://gist.github.com/ivanhub/c6c8e7c170bb3b515b3e2d0a119c2336
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Wireless\GPTWirelessPolicy"
#uwfmgr file add-exclusion "$env:WinDir\wlansvc\Policies"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\wlansvc"
#uwfmgr file add-exclusion "$env:ALLUSERSPROFILE\Microsoft\wlansvc\Profiles\Interfaces"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Wlansvc"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\WwanSvc"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WiredL2\GP_Policy"
#uwfmgr file add-exclusion "$env:WinDir\dot2svc\Policies"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\dot3svc"
#uwfmgr file add-exclusion "$env:ALLUSERSPROFILE\Microsoft\dot3svc\Profiles\Interfaces"
#uwfmgr registry add-exclusion "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\dot3svc"
#uwfmgr file add-exclusion "$env:WinDir\Prefetch"
#uwfmgr file add-exclusion "$env:WinDir\bootstat.dat"

uwfmgr overlay set-size 8192
uwfmgr overlay set-warningthreshold 6000
uwfmgr overlay set-criticalthreshold 7800
