Write-Host "사용자 하이브(HKU) 정책 설정 중..."

# HKU 아래 SID/DEFAULT 키 나열
$targets = Get-ChildItem Registry::HKEY_USERS | Where-Object {
    $_.Name -match "DEFAULT" -or $_.Name -match "S-1-5-\d+-\d+"
}

foreach ($sid in $targets) {
    $sidPath = $sid.PSChildName
    Write-Host "적용 대상: HKU\$sidPath"

    # == Policy Registry Keys ==
    # ActiveDesktop
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "ForceActiveDesktopOn" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoActiveDesktop" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoActiveDesktopChanges" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoAddingComponents" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoEditingComponents" -Value 1 -PropertyType DWord -Force

    # Control Panel & Explorer Restrictions (일부 예시, 나머지도 같은 방식 반복)
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoCloseDragDropBands" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 255 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoInternetIcon" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRecentDocsHistory" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSettings" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoThemesTab" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "RestrictCpl" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Programs" -Name "NoWindowsFeatures" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispAppearancePage" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoDispCPL" -Value 1 -PropertyType DWord -Force

    # Disable internet explorer
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "NotifyDisableIEOptions" -Value 1 -PropertyType DWord -Force
    
    # DisallowRun 예시 (다수 프로그램 차단)
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisallowRun" -Value 1 -PropertyType DWord -Force
    $blockList = @(
        "powershell.exe","powershell_ise.exe","cmd.exe","SystemSettings.exe",
        "ServerManager.exe","ServerManagerLauncher.exe","Taskmgr.exe","mmc.exe",
        "msconfig.exe","regedit.exe","Registry_Management.exe","Scratch Desktop.exe",
        "arduino.exe","VideoPlayer.exe","J-Player.exe","iexplore.exe","mspub.exe",
        "onenote.exe","msaccess.exe","excel.exe","winword.exe","powerpnt.exe",
        "hwp.exe","ODTEditor.exe","wordpad.exe","notepad.exe","WmsManager.exe",
        "WmsSelfHealingSvc.exe","WmsSessionAgent.exe","WmsShell.exe","WmsSvc.exe",
        "mstsc.exe","seclogon.exe","runas.exe","notepad++.exe",
        #"Entry.exe","Entry_HW.exe","HncTT.exe","explorer.exe"
    )
    $keyPath = "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun"
    if (-not (Test-Path $keyPath)) { New-Item -Path $keyPath -Force | Out-Null }
    $i = 1
    foreach ($app in $blockList) {
        New-ItemProperty -Path $keyPath -Name "$i" -Value $app -PropertyType MultiString -Force
        $i++
    }

    # REM Restrict Run
    # New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "RestrictRun" -Value 1 -PropertyType DWord -Force
    # New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" -Name "1" -Value "chrome.exe" -PropertyType String -Force
    # New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun" -Name "2" -Value "mstsc.exe" -PropertyType String -Force
    # block installation
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Policies\Microsoft\Windows\Appx" -Name "BlockNonAdminUserInstall" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 1 -PropertyType DWord -Force
    # Disable marketplace
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Programs" -Name "NoWindowsMarketplace" -Value 1 -PropertyType DWord -Force
    # Disable whieboard
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Conferencing" -Name "NoNewWhiteBoard" -Value 1 -PropertyType DWord -Force
    # Disable windows ink
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowWindowsInkWorkspace" -Value 0 -PropertyType DWord -Force
    # start menu
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "Intellimenus" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoChangeStartMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoClose" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoCommonGroups" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoFind" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoNetworkConnections" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRecentDocsHistory" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRecentDocsMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSearchFilesInStartMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSearchProgramsInStartMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSetTaskbar" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSetFolders" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSMConfigurePrograms" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMorePrograms" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuNetworkPlaces" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuPinnedList" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuSubFolders" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "ShowRunAsDifferentUserInStart" -Value 0 -PropertyType DWord -Force
    # Disable the Run command
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRun" -Value 1 -PropertyType DWord -Force
    # Disable Task View
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -PropertyType DWord -Force
    # Disable Hover Select Desktop
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "HoverSelectDesktops" -Value 0 -PropertyType DWord -Force
    # Disable Winkey Shortcut
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWinKeys" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "NoWinKeys" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisabledHotkeys" -Value "DMTXL" -PropertyType String -Force
    # Disable Tray Context Menu
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideClock" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAHealth" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAVolume" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSMConfigurePrograms" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoTrayContextMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoTrayItemsDisplay" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoToolbarsOnTaskbar" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoViewContextMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarLockAll" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "TaskbarNoResize" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableContextMenusInStart" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToDestinations" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningToTaskbar" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Explorer" -Name "TaskbarNoPinnedList" -Value 1 -PropertyType DWord -Force
    # restrict account
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableChangePassword" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableLockWorkstation" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoUserAccountControl" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoLogoff" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "StartMenuLogOff" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoUserSwitch" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAccessControlPanel" -Value 1 -PropertyType DWord -Force
    # No Network
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Network" -Name "NoEntireNetwork" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Network Connections" -Name "NC_LanProperties" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Network Connections" -Name "NC_LanChangeProperties" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows\Network Connections" -Name "NC_RasConnect" -Value 1 -PropertyType DWord -Force
    # Explorer
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoPreviewPane" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoNetConnectDisconnect" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "AlwaysShowClassicMenu" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoFolderOptions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoFileMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoShellSearchButton" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "ExplorerRibbonStartsMinimized" -Value 1 -PropertyType DWord -Force
    # Disable Resmon
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableResmon" -Value 1 -PropertyType DWord -Force
    # Disable MSConfig
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableMSCONFIG" -Value 1 -PropertyType DWord -Force
    # Disable TaskMng
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableTaskMgr" -Value 1 -PropertyType DWord -Force
    # Disable GPedit
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" -Name "Restrict_Run" -Value 1 -PropertyType DWord -Force
    # Disable Regedit
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableRegistryTools" -Value 1 -PropertyType DWord -Force
    # Disable USB Storage
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4 -PropertyType DWord -Force
    # restrict drivers
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDrives" -Value 0 -PropertyType DWord -Force
    # New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDrives" -Value 67108863 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoViewOnDrive" -Value 0 -PropertyType DWord -Force
    # New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoViewOnDrive" -Value 67108863 -PropertyType DWord -Force

    # PowerShell/CMD Disable 예시
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -Name "DisablePowerShell" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows" -Name "DisableCMD" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisableBatch" -Value 1 -PropertyType DWord -Force

    # ... (나머지 New-ItemProperty -Path들도 동일하게 New-ItemProperty or Set-ItemProperty로 추가 가능)
}

Write-Host "정책 적용 완료. 그룹 정책 새로 고침 실행..."
gpupdate /Force
