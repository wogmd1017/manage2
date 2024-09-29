CD c:\windows\system32
REM prevent changing desktop background of current user
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f
REM prevent control box and desktop change
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCloseDragDropBands" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetIcon" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 0 /f
REM disable internet explorer 
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "NotifyDisableIEOptions" /t REG_DWORD /d 1 /f
REM dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64
REM disallowrun
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_MULTI_SZ /d "notepad.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "iexplore.exe" /f
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "3" /t REG_MULTI_SZ /d "powershell.exe" /f
REM block installation
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Appx" /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer" /v "AlwaysInstallElevated" /t REG_DWORD /d 1 /f
REM Disable powershell
reg add "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v "DisablePowerShell" /t REG_DWORD /d 1 /f
REM Disable windows ink
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f
REM Disable whieboard
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Conferencing" /v "NoNewWhiteBoard" /t REG_DWORD /d 1 /f
REM Disable CMD
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows" /v "DisableCMD" /t REG_DWORD /d 2 /f
REM Disable Regedit
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
REM Disable USB Storage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 4 /f
REM UAC enable
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
gpupdate /force
