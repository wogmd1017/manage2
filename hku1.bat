setlocal

FOR /F "tokens=2* delims=\" %%a IN ('REG QUERY HKU ^|Findstr /R "DEFAULT S-1-5-[0-9]*-[0-9-]*$"') DO (
REM prevent changing desktop background of current user
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f
REM prevent control box and desktop change
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 0 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoAddingComponents" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoEditingComponents" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCloseDragDropBands" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetIcon" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSettings" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoThemesTab" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictCpl" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Programs" /v "NoWindowsFeatures" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispAppearancePage" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoDispCPL" /t REG_DWORD /d 1 /f
REM disable internet explorer 
reg add "HKU\%%a\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "NotifyDisableIEOptions" /t REG_DWORD /d 1 /f
REM dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64
REM disallowrun
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_MULTI_SZ /d "powershell.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "powershell_ise.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "3" /t REG_MULTI_SZ /d "cmd.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "4" /t REG_MULTI_SZ /d "SystemSettings.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "5" /t REG_MULTI_SZ /d "ServerManager.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "6" /t REG_MULTI_SZ /d "ServerManagerLauncher.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "7" /t REG_MULTI_SZ /d "Taskmgr.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "8" /t REG_MULTI_SZ /d "mmc.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "9" /t REG_MULTI_SZ /d "msconfig.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "10" /t REG_MULTI_SZ /d "regedit.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "11" /t REG_MULTI_SZ /d "Registry_Management.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "12" /t REG_MULTI_SZ /d "Scratch Desktop.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "13" /t REG_MULTI_SZ /d "Entry.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "14" /t REG_MULTI_SZ /d "Entry_HW.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "15" /t REG_MULTI_SZ /d "arduino.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "16" /t REG_MULTI_SZ /d "VideoPlayer.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "17" /t REG_MULTI_SZ /d "J-Player.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "18" /t REG_MULTI_SZ /d "iexplore.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "19" /t REG_MULTI_SZ /d "mspub.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "20" /t REG_MULTI_SZ /d "onenote.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "21" /t REG_MULTI_SZ /d "msaccess.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "22" /t REG_MULTI_SZ /d "excel.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "23" /t REG_MULTI_SZ /d "winword.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "24" /t REG_MULTI_SZ /d "powerpnt.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "25" /t REG_MULTI_SZ /d "HncTT.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "26" /t REG_MULTI_SZ /d "hwp.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "27" /t REG_MULTI_SZ /d "ODTEditor.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "28" /t REG_MULTI_SZ /d "wordpad.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "29" /t REG_MULTI_SZ /d "notepad.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "30" /t REG_MULTI_SZ /d "WmsManager.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "31" /t REG_MULTI_SZ /d "WmsSelfHealingSvc.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "32" /t REG_MULTI_SZ /d "WmsSessionAgent.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "33" /t REG_MULTI_SZ /d "WmsShell.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "34" /t REG_MULTI_SZ /d "WmsSvc.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "35" /t REG_MULTI_SZ /d "mstsc.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "36" /t REG_MULTI_SZ /d "seclogon.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "37" /t REG_MULTI_SZ /d "runas.exe" /f
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "38" /t REG_MULTI_SZ /d "notepad++.exe" /f
REM reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "39" /t REG_MULTI_SZ /d "explorer.exe" /f
REM Restrict Run
REM reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "RestrictRun" /t REG_DWORD /d 1 /f
REM reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" /v "1" /t REG_SZ /d "chrome.exe" /f
REM reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" /v "1" /t REG_SZ /d "mstsc.exe" /f
REM block installation
reg add "HKU\%%a\SOFTWARE\Policies\Microsoft\Windows\Appx" /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Installer" /v "AlwaysInstallElevated" /t REG_DWORD /d 1 /f
REM Disable marketplace
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Programs" /v "NoWindowsMarketplace" /t REG_DWORD /d 1 /f
REM Disable whieboard
reg add "HKU\%%a\Software\Policies\Microsoft\Conferencing" /v "NoNewWhiteBoard" /t REG_DWORD /d 1 /f
REM Disable windows ink
reg add "HKU\%%a\Software\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f
REM start menu
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "Intellimenus" /t REG_DWORD /d 0 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoChangeStartMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCommonGroups" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFind" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNetworkConnections" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSearchFilesInStartMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSearchProgramsInStartMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSetTaskbar" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSetFolders" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSMConfigurePrograms" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMorePrograms" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuNetworkPlaces" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuPinnedList" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuSubFolders" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "ShowRunAsDifferentUserInStart" /t REG_DWORD /d 0 /f
REM Disable the Run command
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f
REM Disable Task View
reg add "HKU\%%a\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f
REM Disable Hover Select Desktop
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "HoverSelectDesktops" /t REG_DWORD /d 0 /f
REM Disable Winkey Shortcut
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisabledHotkeys" /t REG_SZ /d "DMTXL" /f
REM Disable Tray Context Menu
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideClock" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAVolume" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSMConfigurePrograms" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayContextMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayItemsDisplay" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoToolbarsOnTaskbar" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewContextMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "TaskbarLockAll" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "TaskbarNoResize" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "DisableContextMenusInStart" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "NoPinningToDestinations" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "NoPinningToTaskbar" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Explorer" /v "TaskbarNoPinnedList" /t REG_DWORD /d 1 /f
REM restrict account
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableChangePassword" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoUserAccountControl" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLogoff" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "StartMenuLogOff" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoUserSwitch" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAccessControlPanel" /t REG_DWORD /d 1 /f
REM No Network
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Network" /v "NoEntireNetwork" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_LanProperties" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_LanChangeProperties" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Policies\Microsoft\Windows\Network Connections" /v "NC_RasConnect" /t REG_DWORD /d 1 /f
REM Explorer
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPreviewPane" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNetConnectDisconnect" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AlwaysShowClassicMenu" /t REG_DWORD /d 0 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFolderOptions" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileMenu" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoShellSearchButton" /t REG_DWORD /d 1 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ExplorerRibbonStartsMinimized" /t REG_DWORD /d 1 /f
REM Disable Resmon
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableResmon" /t REG_DWORD /d 1 /f
REM Disable MSConfig
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableMSCONFIG" /t REG_DWORD /d 1 /f
REM Disable TaskMng
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f
REM Disable GPedit
reg add "HKU\%%a\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" /v "Restrict_Run" /t REG_DWORD /d 1 /f
REM Disable Regedit
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
REM Disable USB Storage
reg add "HKU\%%a\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 4 /f
REM restrict drivers
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 67108863 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewOnDrive" /t REG_DWORD /d 67108863 /f
REM Disable powershell
reg add "HKU\%%a\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v "DisablePowerShell" /t REG_DWORD /d 1 /f
REM Disable CMD
reg add "HKU\%%a\Software\Policies\Microsoft\Windows" /v "DisableCMD" /t REG_DWORD /d 2 /f
reg add "HKU\%%a\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableBatch" /t REG_DWORD /d 1 /f
)
endlocal
gpupdate /force
