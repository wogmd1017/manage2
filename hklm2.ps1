function Apply-Common {
    Write-Host "공통 설정 적용 중..."
    
    # Logon
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "SyncForegroundPolicy" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\System" -Name "DisableForceUnload" -Value 1 -PropertyType DWord -Force

    # prevent changing desktop background
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -Value 1 -PropertyType DWord -Force

    # Chrome 정책
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "AllowDeletingBrowserHistory" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "AllowDinosaurEasterEgg" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "AutofillAddressEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BlockExternalExtensions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BrowserAddPersonEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BrowserGuestModeEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "BrowserThemeColor" -Value "#000000" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DeveloperToolsAvailability" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DeveloperToolsDisabled" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "GoogleSearchSidePanelEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "HideWebStoreIcon" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "IncognitoModeAvailability" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NTPCustomBackgroundEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "SideSearchEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist" -Name "1" -Value "*" -PropertyType String -Force

    # URLBlocklist (1~27)
    $blocklist = @{
        "1"  = "chrome://settings"
        "2"  = "chrome://settings/*"
        "3"  = "chrome://history"
        "4"  = "chrome://history/*"
        "5"  = "chrome://extensions"
        "6"  = "chrome://extensions/*"
        "7"  = "chrome://flags"
        "8"  = "chrome://flags/*"
        "9"  = "chrome://signin-internals"
        "10" = "chrome://signin-internals/*"
        "11" = "chrome://management"
        "12" = "chrome://management/*"
        "13" = "chrome://net-internals"
        "14" = "chrome://net-internals/*"
        "15" = "chrome://chrome-urls"
        "16" = "chrome://chrome-urls/*"
        "17" = "chrome://device-log"
        "18" = "chrome://device-log/*"
        "19" = "chrome://system"
        "20" = "chrome://system/*"
        "21" = "chromewebstore.google.com"
        "22" = "chromewebstore.google.com/*"
        "23" = "ftp://*"
        "24" = "file://*"
        "25" = "data:*"
        "26" = "javascript:*"
        "27" = "filesystem:*"
        # "28" = "chrome://*"
        # "29" = "*"
    }
    foreach ($k in $blocklist.Keys) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name $k -Value $blocklist[$k] -PropertyType String -Force
    }

    # URLAllowlist (1~18)
    $allowlist = @{
        "1"  = "chrome-untrusted://*"
        "2"  = "chrome-extension://*"
        "3"  = "chrome://newtab/"
        "4"  = "chrome://os-settings/"
        "5"  = "chrome://resources/"
        "6"  = "chrome://theme/"
        "7"  = "chrome://favicon/"
        "8"  = "chrome://user-actions/"
        "9"  = "chrome://version/"
        "10" = "chrome://error/"
        "11" = "chrome://welcome/"
        "12" = "chrome://policy/"
        "13" = "apis.google.com"
        "14" = "googleapis.com"
        "15" = "gstatic.com"
        "16" = "colab.research.google.com"
        "17" = "github.com/wogmd1017/class2024"
        "18" = "githubassets.com"
    }
    foreach ($k in $allowlist.Keys) {
        New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
    }

    # Edge 관련
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "AllowDeletingBrowserHistory" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "AllowSurfGame" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "AutofillAddressEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "BlockExternalExtensions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "BrowserGuestModeEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "DeveloperToolsAvailability" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "FullscreenAllowed" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "InPrivateModeAvailability" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "NewTabPageAllowedBackgroundTypes" -Value 3 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "WebCaptureEnabled" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge" -Name "WebWidgetAllowed" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge\URLBlocklist" -Name "1" -Value "edge://settings" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge\URLBlocklist" -Name "2" -Value "edge://history" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge\URLBlocklist" -Name "3" -Value "microsoftedge.microsoft.com/addons" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Edge\URLBlocklist" -Name "4" -Value "*" -PropertyType String -Force
    
    # explorer setting
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "NoBrowser" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "NotifyDisableIEOptions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Name "DisableDeleteBrowsingHistory" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Privacy" -Name "CleanHistory" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Internet Explorer\Privacy" -Name "EnableInPrivateBrowsing" -Value 1 -PropertyType DWord -Force
    # dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64
    # prevent control box and desktop change
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "ForceActiveDesktopOn" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoActiveDesktop" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoActiveDesktopChanges" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAddingComponents" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoControlPanel" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Value 255 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoEditingComponents" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoInternetIcon" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoNetworkConnections" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoPowerOptions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoRecentDocsHistory" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoSetTaskbar" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -Value "showonly:" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableUserSwitch" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoSystemPage" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoUserAccountControl" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Uninstall" -Name "NoStore" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowVPN" -Name "value" -Value 0 -PropertyType DWord -Force
    # SRP
    New-ItemProperty `
      -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" `
      -Name "DefaultLevel" `
      -PropertyType DWord `
      -Value 0x00040000 `
      -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" -Name "PolicyScope" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" -Name "TransparentEnabled" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" -Name "AuthenticodeEnabled" -Value 0 -PropertyType DWord -Force
    # moviemk.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "ItemData" -Value "C:\Program Files (x86)\Windows Live\Photo Gallery\moviemk.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # mspaint.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "ItemData" -Value "%SystemRoot%\System32\mspaint.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Microsoft.Photos.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "ItemData" -Value "%ProgramFiles%\WindowsApps\Microsoft.Windows.Photos_*\Microsoft.Photos.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # WindowsCamera.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "ItemData" -Value "%ProgramFiles%\WindowsApps\Microsoft.WindowsCamera_*\WindowsCamera.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Magnify.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "ItemData" -Value "%SystemRoot%\System32\Magnify.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # AcroRD32.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "ItemData" -Value "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # Explorer.exe
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "ItemData" -Value "C:\Windows\explorer.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "SaferFlags" -Value 0 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" -Name "Level" -Value 0 -PropertyType DWord -Force
    # disallowrun
    # New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisallowRun" -Value 1 -PropertyType DWord -Force
    # New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "1" -Value "notepad.exe" -PropertyType MultiString -Force
    # New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "2" -Value "iexplore.exe" -PropertyType MultiString -Force
    # New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "2" -Value "powershell.exe" -PropertyType MultiString -Force
    # disable hot keys
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoWinKeys" -Value 1 -PropertyType DWord -Force
    New-ItemProperty `
      -Path "HKLM:\System\CurrentControlSet\Control\Keyboard Layout" `
      -Name "Scancode Map" `
      -PropertyType Binary `
      -Value ([byte[]](0x00,0x00,0x00,0x00,
                      0x00,0x00,0x00,0x00,
                      0x03,0x00,0x00,0x00,
                      0xE0,0x5B,0x00,0x00,
                      0xE0,0x5C,0x00,0x00,
                      0x00,0x00,0x00,0x00)) `
      -Force
    # block installation
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx" -Name "BlockNonAdminUserInstall" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name "DisableMSI" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 1 -PropertyType DWord -Force
    # Disable Tray Context Menu
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoTrayContextMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoViewContextMenu" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableContextMenusInStart" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideRunAsVerb" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartBanner" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Classes\batfile\shell\runasuser" -Name "SuppressionPolicy" -Value 4096 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Classes\cmdfile\shell\runasuser" -Name "SuppressionPolicy" -Value 4096 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Classes\exefile\shell\runasuser" -Name "SuppressionPolicy" -Value 4096 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Classes\mscfile\shell\runasuser" -Name "SuppressionPolicy" -Value 4096 -PropertyType DWord -Force
    # Disable file and printer sharing
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network" -Name "NoFileSharing" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network" -Name "NoPrintSharing" -Value 1 -PropertyType DWord -Force
    # Disable powershell
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell" -Name "DisablePowerShell" -Value 1 -PropertyType DWord -Force
    # Disable URI
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableAppUriHandlers" -Value 0 -PropertyType DWord -Force
    # Disable windows ink
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowWindowsInkWorkspace" -Value 0 -PropertyType DWord -Force
    # Disable power button
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start" -Name "HidePowerButton" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start" -Name "HideShutDown" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HidePowerOptions" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "HideFastUserSwitching" -Value 1 -PropertyType DWord -Force
    # Disable Regedit
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableRegistryTools" -Value 1 -PropertyType DWord -Force
    # Disable USB Storage
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4 -PropertyType DWord -Force
    # Disable Start Menu
    New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\TileDataModelSvc" -Name "Start" -Value 4 -PropertyType DWord -Force
    New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMorePrograms" -Value 1 -PropertyType DWord -Force
    # UAC enable
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -PropertyType DWord -Force
    # Disable CMD
    New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "DisableCMD" -Value 2 -PropertyType DWord -Force
}

function Apply-Choice($num) {
    switch ($num) {
        "1" {
            Apply-Common
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "NewTabPageLocation" -Value "https://gyeongnam-gm-m.elice.io" -PropertyType String -Force
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name "28" -Value "http://*" -PropertyType String -Force
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLBlocklist" -Name "29" -Value "https://*" -PropertyType String -Force
            # URLAllowlist (19~35)
            $allowlist = @{
                "19"  = "*.elice.io/*"
                "20"  = "accounts.elice.io"
                "21"  = "testroom.elice.io"
                "22"  = "api-activity.elice.io"
                "23"  = "api-rest.elice.io"
                "24"  = "api-cms.elice.io"
                "25"  = "api-course.elice.io"
                "26"  = "gyeongnam-gm-m.elice.io"
                "27" = "googleusercontent.com"
                "28" = "account.google.com"
                "29" = "account.google.co.kr"
                "30" = "accounts.google.com"
                "31" = "accounts.google.co.kr"
                # "32" = "www.onlinegdb.com"
                }
            foreach ($k in $allowlist.Keys) {
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\URLAllowlist" -Name $k -Value $allowlist[$k] -PropertyType String -Force
                }
            gpupdate /force
        }
        # ... 동일하게 :2, :3, :4, :6, :7, :8, :9 전부 변환
    }
}

while ($true) {
    Clear-Host
    Write-Host "================================================"
    Write-Host "1. HKLM for elice.io (Python)"
    Write-Host "2. HKLM for Hamster (Entry)"
    Write-Host "3. HKLM for 1g app inventor"
    Write-Host "4. HKLM for 1g AI"
    Write-Host "6. delete 1."
    Write-Host "7. delete 2."
    Write-Host "8. delete 3."
    Write-Host "9. delete 4."
    Write-Host "================================================"
    $choice = Read-Host "Choose work number"
    Apply-Choice $choice
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다."
}
