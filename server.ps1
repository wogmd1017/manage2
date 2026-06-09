#Requires -RunAsAdministrator

# ============================================================
#  server.ps1 - Lab server / student PC management script
#  Usage: via Invoke-Command or run locally on server
# ============================================================

$GithubBase = "https://raw.githubusercontent.com/wogmd1017/manage2/main"
$DataPath   = "C:\Users\manager\Desktop\data"

# ============================================================
#  0. Init
# ============================================================
function Initialize-Server {
    Write-Host "[Init] Downloading config files..." -ForegroundColor Cyan

    if (-not (Test-Path $DataPath)) { New-Item -ItemType Directory -Path $DataPath -Force | Out-Null }

    Invoke-WebRequest "$GithubBase/config.psd1" -OutFile "$DataPath\config.psd1" -UseBasicParsing
    Invoke-WebRequest "$GithubBase/modes.psd1"  -OutFile "$DataPath\modes.psd1"  -UseBasicParsing

    $script:Config = Import-PowerShellDataFile "$DataPath\config.psd1"
    $script:Modes  = Import-PowerShellDataFile "$DataPath\modes.psd1"

    # ServerId from last IP octet
    $ip = (Get-NetIPAddress -AddressFamily IPv4 |
           Where-Object { $_.IPAddress -notmatch "^127\." -and $_.IPAddress -notmatch "^169\." } |
           Select-Object -First 1).IPAddress
    $script:ServerId = "st" + $ip.Split(".")[-1]

    # Find Chrome exe
    $script:ChromeExe = $Config.ChromePath | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $script:ChromeExe) {
        Write-Host "[Init] WARNING: Chrome not found" -ForegroundColor Yellow
    }

    Write-Host "[Init] Done (ServerId: $script:ServerId)" -ForegroundColor Green
}

# ============================================================
#  1. PsExec
# ============================================================
function Get-PsExec {
    Write-Host "[PsExec] Checking..." -ForegroundColor Cyan

    $psexecPath = "$DataPath\PsExec.exe"
    if (-not (Test-Path $psexecPath)) {
        Write-Host "[PsExec] Downloading..." -ForegroundColor Cyan
        Invoke-WebRequest "https://live.sysinternals.com/PsExec.exe" -OutFile $psexecPath -UseBasicParsing
    }
    # Accept EULA silently
    & $psexecPath -accepteula 2>$null
    Write-Host "[PsExec] Done" -ForegroundColor Green
}

# ============================================================
#  2. Cleanup startup items
# ============================================================
function Clear-StartupItems {
    Write-Host "[Cleanup] Removing startup items..." -ForegroundColor Cyan

    # Remove mspaint, SnippingTool
    foreach ($exe in @("mspaint.exe", "SnippingTool.exe")) {
        $path = "C:\Windows\System32\$exe"
        if (Test-Path $path) {
            icacls $path /setowner Administrator /C | Out-Null
            icacls $path /grant "Administrator:F" /C | Out-Null
            Remove-Item $path -Force -ErrorAction SilentlyContinue
        }
    }

    # Clear public desktop
    Get-ChildItem "C:\Users\Public\Desktop" -Recurse |
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

    # Clear start menu programs
    $startMenu = "C:\ProgramData\Microsoft\Windows\Start Menu"
    if (Test-Path "$startMenu\Programs") {
        Remove-Item "$startMenu\Programs" -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Clear WinX and start menu per student
    foreach ($stu in $Config.Students) {
        $winx     = "C:\Users\$stu\AppData\Local\Microsoft\Windows\WinX"
        $startStu = "C:\Users\$stu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
        if (Test-Path $winx)     { Remove-Item $winx     -Recurse -Force -ErrorAction SilentlyContinue }
        if (Test-Path $startStu) { Remove-Item $startStu -Recurse -Force -ErrorAction SilentlyContinue }
    }

    Write-Host "[Cleanup] Done" -ForegroundColor Green
}

# ============================================================
#  3. Schedulers
# ============================================================
function Register-Schedulers {
    Write-Host "[Scheduler] Registering..." -ForegroundColor Cyan

    Invoke-WebRequest "$GithubBase/hostup.bat" -OutFile "$DataPath\hostup.bat" -UseBasicParsing
    Invoke-WebRequest "$GithubBase/hisup.bat"  -OutFile "$DataPath\hisup.bat"  -UseBasicParsing

    schtasks /create /tn "hostup" /tr "$DataPath\hostup.bat" /sc minute        /rl highest /f | Out-Null
    schtasks /create /tn "hisup"  /tr "$DataPath\hisup.bat"  /sc minute /mo 3  /rl highest /f | Out-Null

    & "$DataPath\hostup.bat"
    Start-Process "$DataPath\hisup.bat" -WindowStyle Minimized

    Write-Host "[Scheduler] Done" -ForegroundColor Green
}

# ============================================================
#  4. Permissions (icacls)
# ============================================================
function Set-Permissions {
    Write-Host "[Permissions] Applying icacls..." -ForegroundColor Cyan

    icacls "C:\Program Files"       /inheritance:e /c /l /q | Out-Null
    icacls "C:\Program Files (x86)" /inheritance:e /c /l /q | Out-Null

    foreach ($stu in $Config.Students) {
        icacls "C:\Users\$stu"         /c /deny "${stu}:W"              | Out-Null
        icacls "C:\Users\$stu\Desktop" /grant "${stu}:RX" /deny "${stu}:W" /c | Out-Null

        foreach ($dir in @("C:\Program Files","C:\Program Files (x86)","C:\ProgramData","C:\Entry","C:\Entry_HW")) {
            if (Test-Path $dir) {
                icacls $dir /deny "${stu}:(OI)(CI)(X)" /c /l /q | Out-Null
            }
        }

        foreach ($chromePath in $Config.ChromePath) {
            if (Test-Path $chromePath) {
                icacls $chromePath /grant "${stu}:(RX)" /c | Out-Null
            }
        }
    }

    Write-Host "[Permissions] Done" -ForegroundColor Green
}

# ============================================================
#  5. Stop Chrome + clean data  (end of class)
# ============================================================
function Stop-ChromeAndClean {
    Write-Host "[Clean] Stopping Chrome and clearing data..." -ForegroundColor Cyan

    $killList = @(
        "chrome","mspaint","hwp","HncTT","ODTEditor","Hword",
        "excel","winword","powerpnt","wordpad","mspub","msaccess",
        "onenote","ms-teams","Teams","TeamsInstaller","zoom","notepad",
        "Scratch Desktop","Scratch 3","Entry","Entry_HW","CodingSchool3",
        "arduino","code"
    )
    foreach ($proc in $killList) {
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
    }

    Start-Sleep -Seconds 3

    foreach ($stu in $Config.Students) {
        $ud = "C:\Users\$stu\AppData\Local\Google\Chrome\User Data"
        if (-not (Test-Path $ud)) { continue }

        foreach ($f in @("Local State","Last Version","Last Tabs")) {
            Remove-Item "$ud\$f" -Force -ErrorAction SilentlyContinue
        }

        Get-ChildItem $ud -Directory |
            Where-Object { Test-Path "$($_.FullName)\Cookies" } |
            ForEach-Object {
                $prof = $_.FullName
                Remove-Item "$prof\Cookies"         -Force          -ErrorAction SilentlyContinue
                Remove-Item "$prof\Network\Cookies" -Force          -ErrorAction SilentlyContinue
                Remove-Item "$prof\Last Tabs"       -Force          -ErrorAction SilentlyContinue
                Remove-Item "$prof\Last Session"    -Force          -ErrorAction SilentlyContinue
                Remove-Item "$prof\Sessions"        -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "$prof\Session Storage" -Recurse -Force -ErrorAction SilentlyContinue
            }
    }

    Write-Host "[Clean] Done" -ForegroundColor Green
}

# ============================================================
#  6. HKLM policy (common + mode URL)
# ============================================================
function Set-HKLMPolicy {
    param([string]$Mode)
    Write-Host "[HKLM] Applying policy (mode: $Mode)..." -ForegroundColor Cyan

    $cp  = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome"
    $ep  = "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge"
    $exp = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $ifo = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"

    # Chrome common
    reg add $cp /v "AllowDeletingBrowserHistory"     /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "AllowDinosaurEasterEgg"          /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "AutofillAddressEnabled"          /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "BackgroundModeEnabled"           /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "BlockExternalExtensions"         /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "BrowserAddPersonEnabled"         /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "BrowserGuestModeEnabled"         /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "BrowserThemeColor"               /t REG_SZ    /d "#000000" /f | Out-Null
    reg add $cp /v "DeveloperToolsAvailability"      /t REG_DWORD /d 2        /f | Out-Null
    reg add $cp /v "DeveloperToolsDisabled"          /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "GoogleSearchSidePanelEnabled"    /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "HideRestoreInProgressBackground" /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "HideWebStoreIcon"                /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "HighEfficiencyModeEnabled"       /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "IncognitoModeAvailability"       /t REG_DWORD /d 1        /f | Out-Null
    reg add $cp /v "MaxTabs"                         /t REG_DWORD /d 7        /f | Out-Null
    reg add $cp /v "NTPCustomBackgroundEnabled"      /t REG_DWORD /d 0        /f | Out-Null
    reg add $cp /v "RestoreOnStartup"                /t REG_DWORD /d 5        /f | Out-Null
    reg add $cp /v "SideSearchEnabled"               /t REG_DWORD /d 0        /f | Out-Null
    reg add "$cp\ClearBrowsingDataOnExitList" /v "1" /t REG_SZ /d "cookies_and_other_site_data" /f | Out-Null
    reg add "$cp\ClearBrowsingDataOnExitList" /v "2" /t REG_SZ /d "password_signin"             /f | Out-Null
    reg add "$cp\ExtensionInstallBlocklist"   /v "1" /t REG_SZ /d "*"                           /f | Out-Null

    # Chrome common URLBlocklist (1-27)
    $commonBlock = @(
        "chrome://settings","chrome://settings/*","chrome://history",
        "chrome://history/*","chrome://extensions","chrome://extensions/*",
        "chrome://flags","chrome://flags/*","chrome://signin-internals",
        "chrome://signin-internals/*","chrome://management","chrome://management/*",
        "chrome://net-internals","chrome://net-internals/*","chrome://chrome-urls",
        "chrome://chrome-urls/*","chrome://device-log","chrome://device-log/*",
        "chrome://system","chrome://system/*","chromewebstore.google.com",
        "chromewebstore.google.com/*","ftp://*","file://*","data:*",
        "javascript:*","filesystem:*"
    )
    for ($i = 0; $i -lt $commonBlock.Count; $i++) {
        reg add "$cp\URLBlocklist" /v ($i+1) /t REG_SZ /d $commonBlock[$i] /f | Out-Null
    }

    # Chrome common URLAllowlist (1-18)
    $commonAllow = @(
        "chrome-untrusted://*","chrome-extension://*","chrome://newtab/",
        "chrome://os-settings/","chrome://resources/","chrome://theme/",
        "chrome://favicon/","chrome://user-actions/","chrome://version/",
        "chrome://error/","chrome://welcome/","chrome://policy/",
        "apis.google.com","googleapis.com","gstatic.com",
        "github.com/wogmd1017/class2024","githubassets.com"
    )
    for ($i = 0; $i -lt $commonAllow.Count; $i++) {
        reg add "$cp\URLAllowlist" /v ($i+1) /t REG_SZ /d $commonAllow[$i] /f | Out-Null
    }

    # Mode-specific URL policy
    $m = $Modes[$Mode]
    if ($m.NewTabPage) {
        reg add $cp /v "NewTabPageLocation" /t REG_SZ /d $m.NewTabPage /f | Out-Null
    }
    for ($i = 0; $i -lt $m.Blocklist.Count; $i++) {
        reg add "$cp\URLBlocklist" /v (28+$i) /t REG_SZ /d $m.Blocklist[$i] /f | Out-Null
    }
    for ($i = 0; $i -lt $m.Allowlist.Count; $i++) {
        reg add "$cp\URLAllowlist" /v (19+$i) /t REG_SZ /d $m.Allowlist[$i] /f | Out-Null
    }

    # Edge
    reg add $ep /v "AllowDeletingBrowserHistory" /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "AllowSurfGame"               /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "AutofillAddressEnabled"      /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "BlockExternalExtensions"     /t REG_DWORD /d 1 /f | Out-Null
    reg add $ep /v "BrowserGuestModeEnabled"     /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "DeveloperToolsAvailability"  /t REG_DWORD /d 2 /f | Out-Null
    reg add $ep /v "FullscreenAllowed"           /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "InPrivateModeAvailability"   /t REG_DWORD /d 1 /f | Out-Null
    reg add $ep /v "WebCaptureEnabled"           /t REG_DWORD /d 0 /f | Out-Null
    reg add $ep /v "WebWidgetAllowed"            /t REG_DWORD /d 0 /f | Out-Null
    reg add "$ep\URLBlocklist" /v "1" /t REG_SZ /d "edge://settings"                       /f | Out-Null
    reg add "$ep\URLBlocklist" /v "2" /t REG_SZ /d "edge://history"                        /f | Out-Null
    reg add "$ep\URLBlocklist" /v "3" /t REG_SZ /d "microsoftedge.microsoft.com/addons"    /f | Out-Null
    reg add "$ep\URLBlocklist" /v "4" /t REG_SZ /d "*"                                     /f | Out-Null

    # Explorer
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper"    /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "ForceActiveDesktopOn"    /t REG_DWORD /d 0   /f | Out-Null
    reg add $exp /v "NoActiveDesktop"         /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoActiveDesktopChanges"  /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoAddingComponents"      /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoControlPanel"          /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoDriveTypeAutoRun"      /t REG_DWORD /d 255 /f | Out-Null
    reg add $exp /v "NoEditingComponents"     /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoInternetIcon"          /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoNetworkConnections"    /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoPowerOptions"          /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "NoSetTaskbar"            /t REG_DWORD /d 1   /f | Out-Null
    reg add $exp /v "SettingsPageVisibility"  /t REG_SZ    /d "showonly:" /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableUserSwitch"    /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoUserAccountControl" /t REG_DWORD /d 1 /f | Out-Null

    # IFEO blocks
    $blockExe = @(
        "SnippingTool.exe","ScreenSketch.exe","powershell_ise.exe","regedit.exe",
        "taskmgr.exe","SystemSettings.exe","msconfig.exe","hwp.exe","HncTT.exe",
        "ODTEditor.exe","Hword.exe","excel.exe","winword.exe","powerpnt.exe",
        "wordpad.exe","mspub.exe","msaccess.exe","onenote.exe","ms-teams.exe",
        "Teams.exe","TeamsInstaller.exe","zoom.exe","notepad.exe","notepad++.exe",
        "Scratch Desktop.exe","Scratch 3.exe","Entry.exe","Entry_HW.exe",
        "CodingSchool3.exe","arduino.exe","code.exe","VRWARE School.exe",
        "python.exe","ServerManager.exe","ServerManagerLauncher.exe",
        "mstsc.exe","VideoPlayer.exe","J-Player.exe","Registry_Management.exe"
    )
    foreach ($exe in $blockExe) {
        reg add "$ifo\$exe" /v Debugger /t REG_SZ /d "systray.exe" /f | Out-Null
    }
    reg add "$ifo\iexplore.exe" /v Debugger /t REG_SZ /d "chrome.exe" /f | Out-Null
    reg add "$ifo\whale.exe"    /v Debugger /t REG_SZ /d "chrome.exe" /f | Out-Null

    # SRP
    $srp = "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers"
    reg add $srp /v "DefaultLevel"        /t REG_DWORD /d 0x00040000 /f | Out-Null
    reg add $srp /v "PolicyScope"         /t REG_DWORD /d 0          /f | Out-Null
    reg add $srp /v "TransparentEnabled"  /t REG_DWORD /d 1          /f | Out-Null
    reg add $srp /v "AuthenticodeEnabled" /t REG_DWORD /d 0          /f | Out-Null

    # Misc system restrictions
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell"                  /v "DisablePowerShell"        /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"                      /v "EnableAppUriHandlers"     /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\Software\Policies\Microsoft\WindowsInkWorkspace"                 /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Start"                  /v "HidePowerButton"          /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Start"                  /v "HideShutDown"             /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System"       /v "DisableRegistryTools"     /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBSTOR"                       /v "Start"                    /t REG_DWORD /d 4 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network"      /v "NoFileSharing"            /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network"      /v "NoPrintSharing"           /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"     /v "NoWinKeys"                /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout"                /v "Scancode Map" /t REG_BINARY /d "00000000000000000300000000005BE000005CE000000000" /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx"                        /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f | Out-Null
    reg add "HKLM\Software\Policies\Microsoft\Windows\Installer"                   /v "DisableMSI"               /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"     /v "NoTrayContextMenu"        /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"     /v "NoViewContextMenu"        /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"  /v "SyncForegroundPolicy"     /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System"                      /v "DisableForceUnload"       /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKLM\SOFTWARE\Policies\Naver\Naver Whale\URLBlocklist"                /v "1"                        /t REG_SZ    /d "*" /f | Out-Null

    Write-Host "[HKLM] Done" -ForegroundColor Green
}

# ============================================================
#  7. HKU policy (all student accounts)
# ============================================================
function Set-HKUPolicy {
    Write-Host "[HKU] Applying policy..." -ForegroundColor Cyan

    $adminSid = (New-Object System.Security.Principal.NTAccount("manager")).Translate(
        [System.Security.Principal.SecurityIdentifier]).Value

    $sids = reg query HKU | Select-String "S-1-5-21-" | ForEach-Object {
        $sid = $_.ToString().Trim().Split("\")[-1]
        if ($sid -notmatch "_Classes" -and $sid -ne $adminSid) { $sid }
    }

    foreach ($sid in $sids) {
        Write-Host "  -> SID: $sid" -ForegroundColor DarkCyan
        $h = "HKU\$sid"

        # Wallpaper
        reg add "$h\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f | Out-Null
        reg add "$h\control panel\Desktop" /v "Wallpaper"      /t REG_SZ    /d "C:\Users\Public\Pictures\wall1.png" /f | Out-Null
        reg add "$h\Control Panel\Desktop" /v "WallpaperStyle" /t REG_SZ    /d "0" /f | Out-Null

        # Explorer restrictions
        $e = "$h\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        reg add "$h\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoAddingComponents"  /t REG_DWORD /d 1   /f | Out-Null
        reg add "$h\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoEditingComponents" /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "ForceActiveDesktopOn"          /t REG_DWORD /d 0   /f | Out-Null
        reg add $e /v "NoActiveDesktop"               /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoActiveDesktopChanges"        /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoControlPanel"                /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoCloseDragDropBands"          /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoDriveTypeAutoRun"            /t REG_DWORD /d 255 /f | Out-Null
        reg add $e /v "NoInternetIcon"                /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoRecentDocsHistory"           /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoSettings"                    /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoThemesTab"                   /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "RestrictCpl"                   /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoRun"                         /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoWinKeys"                     /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoLogoff"                      /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "StartMenuLogOff"               /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoUserSwitch"                  /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoAccessControlPanel"          /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoDrives"                      /t REG_DWORD /d 12  /f | Out-Null
        reg add $e /v "NoViewOnDrive"                 /t REG_DWORD /d 12  /f | Out-Null
        reg add $e /v "NoPreviewPane"                 /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoNetConnectDisconnect"        /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoFolderOptions"               /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoFileMenu"                    /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoShellSearchButton"           /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoTrayContextMenu"             /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoTrayItemsDisplay"            /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoToolbarsOnTaskbar"           /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "NoViewContextMenu"             /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "TaskbarLockAll"                /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "TaskbarNoResize"               /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "HideClock"                     /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "HideSCAHealth"                 /t REG_DWORD /d 1   /f | Out-Null
        reg add $e /v "HideSCAVolume"                 /t REG_DWORD /d 1   /f | Out-Null

        # Start menu
        reg add $e /v "NoChangeStartMenu"             /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoClose"                       /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoCommonGroups"                /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoFind"                        /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoNetworkConnections"          /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoRecentDocsMenu"              /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoSearchFilesInStartMenu"      /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoSearchProgramsInStartMenu"   /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoSetTaskbar"                  /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoSetFolders"                  /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoSMConfigurePrograms"         /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoStartMenuMFUprogramsList"    /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoStartMenuMorePrograms"       /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoStartMenuNetworkPlaces"      /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoStartMenuPinnedList"         /t REG_DWORD /d 1 /f | Out-Null
        reg add $e /v "NoStartMenuSubFolders"         /t REG_DWORD /d 1 /f | Out-Null

        # Taskbar
        $adv = "$h\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        reg add $adv /v "ShowTaskViewButton" /t REG_DWORD /d 0      /f | Out-Null
        reg add $adv /v "DisabledHotkeys"   /t REG_SZ    /d "DMTXL" /f | Out-Null
        $we = "$h\Software\Policies\Microsoft\Windows\Explorer"
        reg add $we /v "DisableContextMenusInStart"    /t REG_DWORD /d 1 /f | Out-Null
        reg add $we /v "DisableNotificationCenter"     /t REG_DWORD /d 1 /f | Out-Null
        reg add $we /v "NoPinningToDestinations"       /t REG_DWORD /d 1 /f | Out-Null
        reg add $we /v "NoPinningToTaskbar"            /t REG_DWORD /d 1 /f | Out-Null
        reg add $we /v "TaskbarNoPinnedList"           /t REG_DWORD /d 1 /f | Out-Null
        reg add $we /v "ShowRunAsDifferentUserInStart" /t REG_DWORD /d 0 /f | Out-Null

        # System restrictions
        $s = "$h\Software\Microsoft\Windows\CurrentVersion\Policies\System"
        reg add $s /v "DisableChangePassword"  /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "NoDispAppearancePage"   /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "NoDispCPL"              /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "DisableResmon"          /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "DisableMSCONFIG"        /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "DisableTaskMgr"         /t REG_DWORD /d 1 /f | Out-Null
        reg add $s /v "DisableRegistryTools"   /t REG_DWORD /d 1 /f | Out-Null

        # Chrome user policy
        reg add "$h\Software\Policies\Google\Chrome" /v "MaxTabs"                  /t REG_DWORD /d 10 /f | Out-Null
        reg add "$h\Software\Policies\Google\Chrome" /v "HighEfficiencyModeEnabled" /t REG_DWORD /d 1  /f | Out-Null
        reg add "$h\Software\Policies\Google\Chrome" /v "BrowserGuestModeEnabled"  /t REG_DWORD /d 0  /f | Out-Null

        # DisallowRun
        $disallow = @(
            "powershell.exe","powershell_ise.exe","cmd.exe","SystemSettings.exe",
            "ServerManager.exe","ServerManagerLauncher.exe","Taskmgr.exe","mmc.exe",
            "msconfig.exe","regedit.exe","Registry_Management.exe","VideoPlayer.exe",
            "J-Player.exe","iexplore.exe","mspub.exe","onenote.exe","msaccess.exe",
            "WmsManager.exe","WmsSelfHealingSvc.exe","WmsSessionAgent.exe",
            "WmsShell.exe","WmsSvc.exe","mstsc.exe","seclogon.exe","runas.exe",
            "ODTEditor.exe","notepad++.exe","HncTT.exe","hwp.exe","wordpad.exe",
            "notepad.exe","excel.exe","winword.exe","powerpnt.exe",
            "Scratch Desktop.exe","Entry.exe","Entry_HW.exe","arduino.exe"
        )
        reg add $e /v "DisallowRun" /t REG_DWORD /d 1 /f | Out-Null
        for ($i = 0; $i -lt $disallow.Count; $i++) {
            reg add "$e\DisallowRun" /v ($i+1) /t REG_MULTI_SZ /d $disallow[$i] /f | Out-Null
        }

        # Network
        reg add "$h\Software\Microsoft\Windows\CurrentVersion\Policies\Network" /v "NoEntireNetwork" /t REG_DWORD /d 1 /f | Out-Null

        # PowerShell / CMD / Script restrictions
        reg add "$h\SOFTWARE\Policies\Microsoft\Windows\PowerShell"                           /v "DisablePowerShell"  /t REG_DWORD /d 1            /f | Out-Null
        reg add "$h\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"            /v "ExecutionPolicy"   /t REG_SZ    /d "Restricted"  /f | Out-Null
        reg add "$h\Software\Microsoft\Windows Script Host\Settings"                          /v "Enabled"           /t REG_DWORD /d 0            /f | Out-Null
        reg add "$h\Software\Policies\Microsoft\Windows\System"                               /v "DisableCMD"        /t REG_DWORD /d 2            /f | Out-Null

        # Misc
        reg add "$h\Software\Policies\Microsoft\Windows\Programs"                            /v "NoWindowsFeatures"    /t REG_DWORD /d 1 /f | Out-Null
        reg add "$h\Software\Policies\Microsoft\Windows\Programs"                            /v "NoWindowsMarketplace"  /t REG_DWORD /d 1 /f | Out-Null
        reg add "$h\Software\Policies\Microsoft\Conferencing"                                /v "NoNewWhiteBoard"      /t REG_DWORD /d 1 /f | Out-Null
        reg add "$h\Software\Policies\Microsoft\WindowsInkWorkspace"                         /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f | Out-Null
        reg add "$h\Software\Classes\regfile\shell\open\command"                             /ve /t REG_SZ /d "notepad.exe `"%1`"" /f | Out-Null
        reg add "$h\SOFTWARE\Policies\Microsoft\Windows\Appx"                               /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f | Out-Null
    }

    # gpupdate once after all registry applied
    Write-Host "[HKU] Running gpupdate..." -ForegroundColor Cyan
    gpupdate /force | Out-Null

    Write-Host "[HKU] Done" -ForegroundColor Green
}
