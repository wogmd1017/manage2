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

    # DisallowRun 예시 (다수 프로그램 차단)
    $blockList = @(
        "powershell.exe","powershell_ise.exe","cmd.exe","SystemSettings.exe",
        "ServerManager.exe","ServerManagerLauncher.exe","Taskmgr.exe","mmc.exe",
        "msconfig.exe","regedit.exe","Registry_Management.exe","Scratch Desktop.exe",
        "arduino.exe","VideoPlayer.exe","J-Player.exe","iexplore.exe","mspub.exe",
        "onenote.exe","msaccess.exe","excel.exe","winword.exe","powerpnt.exe",
        "hwp.exe","ODTEditor.exe","wordpad.exe","notepad.exe","WmsManager.exe",
        "WmsSelfHealingSvc.exe","WmsSessionAgent.exe","WmsShell.exe","WmsSvc.exe",
        "mstsc.exe","seclogon.exe","runas.exe","notepad++.exe"
    )
    $keyPath = "Registry::HKEY_USERS\$sidPath\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun"
    if (-not (Test-Path $keyPath)) { New-Item -Path $keyPath -Force | Out-Null }
    $i = 1
    foreach ($app in $blockList) {
        New-ItemProperty -Path $keyPath -Name "$i" -Value $app -PropertyType MultiString -Force
        $i++
    }

    # Internet Explorer Disable 예시
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "NotifyDisableIEOptions" -Value 1 -PropertyType DWord -Force

    # PowerShell/CMD Disable 예시
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -Name "DisablePowerShell" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Policies\Microsoft\Windows" -Name "DisableCMD" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "Registry::HKEY_USERS\$sidPath\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisableBatch" -Value 1 -PropertyType DWord -Force

    # ... (나머지 reg add들도 동일하게 New-ItemProperty or Set-ItemProperty로 추가 가능)
}

Write-Host "정책 적용 완료. 그룹 정책 새로 고침 실행..."
gpupdate /force
