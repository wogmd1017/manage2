# ============================================================
#  manage.ps1 - Teacher PC management console
#  Run: powershell.exe -File manage.ps1
# ============================================================

$GithubBase  = "https://raw.githubusercontent.com/wogmd1017/manage2/main"
$DataPath    = "$env:USERPROFILE\Desktop\data"
$LockFile    = "$DataPath\loop.lock"
$loopProcess = $null

# ============================================================
#  Init
# ============================================================
function Initialize-Manage {
    if (-not (Test-Path $DataPath)) { New-Item -ItemType Directory -Path $DataPath -Force | Out-Null }
    Write-Host "[Init] Downloading config + scripts..." -ForegroundColor Cyan
    Invoke-WebRequest "$GithubBase/config.psd1" -OutFile "$DataPath\config.psd1" -UseBasicParsing
    Invoke-WebRequest "$GithubBase/server.ps1"  -OutFile "$DataPath\server.ps1"  -UseBasicParsing
    Invoke-WebRequest "$GithubBase/loop.ps1"    -OutFile "$DataPath\loop.ps1"    -UseBasicParsing
    $script:Config = Import-PowerShellDataFile "$DataPath\config.psd1"
    Write-Host "[Init] Done" -ForegroundColor Green
}

# ============================================================
#  Credential
# ============================================================
function Get-Cred {
    $sec = Read-Host "Password for $($script:Config.User)" -AsSecureString
    $script:Cred        = New-Object System.Management.Automation.PSCredential($script:Config.User, $sec)
    $script:EncPassword = $sec | ConvertFrom-SecureString
    Write-Host "[Auth] Ready" -ForegroundColor Green
}

# ============================================================
#  Remote invoke helper
# ============================================================
function Invoke-OnAll {
    param([scriptblock]$Block, [object[]]$ArgList = @())
    Invoke-Command -ComputerName $script:Config.Servers -Credential $script:Cred `
        -ScriptBlock $Block -ArgumentList $ArgList -ErrorAction SilentlyContinue
}

# ============================================================
#  Session: explorer stop + kiosk launch
# ============================================================
function Start-Session {
    $servers = $script:Config.Servers
    $cred    = $script:Cred
    $data    = $script:Config.DataPath
    $url     = $script:Config.KioskUrl
    $user    = $script:Config.User

    Write-Host "[Session] Stopping explorer..." -ForegroundColor Cyan
    Invoke-Command -ComputerName $servers -Credential $cred -ScriptBlock {
        Set-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" `
            -Name "AutoRestartShell" -Value 0 -Type DWord
        Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" | ForEach-Object {
            $owner = $_.GetOwner().User
            if ($owner -notin @('Administrator', $using:user)) {
                $_.Terminate() | Out-Null
                Write-Host "[$env:COMPUTERNAME][$owner] explorer stopped" -ForegroundColor Yellow
            }
        }
    } -ErrorAction SilentlyContinue

    Write-Host "[Session] Waiting 3s..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3

    Write-Host "[Session] Parsing sessions..." -ForegroundColor Cyan
    $initSessions = Invoke-Command -ComputerName $servers -Credential $cred -ScriptBlock {
        (query session 2>$null) | Select-Object -Skip 1 | ForEach-Object {
            if ($_ -match '^\s+(\S+)\s+(\d+)\s+(Active|Disc|활성|디스크)') {
                [PSCustomObject]@{ User = $matches[1]; SessionId = $matches[2] }
            }
        } | Where-Object {
            $_.User -notin @('Administrator', $using:user) -and
            $_.SessionId -match '^\d+$'
        }
    } -ErrorAction SilentlyContinue

    if (-not $initSessions) {
        Write-Host "[Session] No sessions found." -ForegroundColor Red
        return
    }

    Write-Host "[Session] Found $($initSessions.Count) session(s):" -ForegroundColor Cyan
    $initSessions | ForEach-Object {
        Write-Host "  -> [$($_.PSComputerName)][$($_.User)] sid $($_.SessionId)" -ForegroundColor Gray
    }

    $sessionsByServer = $initSessions | Group-Object PSComputerName

    $jobs = foreach ($serverGroup in $sessionsByServer) {
        $serverIP    = $serverGroup.Name
        $sessionData = $serverGroup.Group | ForEach-Object {
            @{ User = $_.User; SessionId = $_.SessionId }
        }
        Start-Job -ScriptBlock {
            param($serverIP, $cred, $sessionData, $url, $data)
            Invoke-Command -ComputerName $serverIP -Credential $cred -ScriptBlock {
                param($sessionData, $url, $data)
                $chrome = (Get-Item `
                    "C:\Program Files\Google\Chrome\Application\chrome.exe",
                    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" `
                    -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
                $psexec = "$data\PsExec.exe"

                foreach ($session in $sessionData) {
                    $sid     = [int]$session.SessionId
                    $owner   = $session.User
                    $profile = "C:\Users\$owner\AppData\Local\Google\Chrome\User Data"
                    $bat     = "C:\Windows\Temp\kiosk_$sid.bat"

                    Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                        Where-Object { $_.SessionId -eq $sid } |
                        ForEach-Object { Stop-Process -Id $_.ProcessId -ErrorAction SilentlyContinue }
                    Start-Sleep -Milliseconds 1000
                    Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                        Where-Object { $_.SessionId -eq $sid } |
                        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
                    Start-Sleep -Milliseconds 500

                    $content = "@echo off`r`n" +
                        "del /f /q `"$profile\Default\Last Session`" >nul 2>&1`r`n" +
                        "del /f /q `"$profile\Default\Last Tabs`" >nul 2>&1`r`n" +
                        "start `"`" `"$chrome`" " +
                        "--kiosk $url " +
                        "--no-first-run " +
                        "--disable-sync " +
                        "--user-data-dir=`"$profile`" " +
                        "--no-default-browser-check " +
                        "--disable-default-apps " +
                        "--disable-extensions " +
                        "--disable-features=ChromeWhatsNewUI " +
                        "--suppress-message-center-popups " +
                        "--disable-pinch " +
                        "--overscroll-history-navigation=0 " +
                        "--noerrdialogs " +
                        "--disable-session-crashed-bubble " +
                        "--kiosk-printing`r`n" +
                        "exit"

                    [System.IO.File]::WriteAllText($bat, $content, [System.Text.Encoding]::ASCII)
                    Write-Host "[$env:COMPUTERNAME][$owner] sid $sid kiosk launch"
                    & $psexec -accepteula -i $sid -s cmd /c $bat 2>&1
                }
            } -ArgumentList $sessionData, $url, $data
        } -ArgumentList $serverIP, $cred, $sessionData, $url, $data
    }

    if ($jobs) {
        $jobs | Wait-Job -Timeout 60 | Out-Null
        $jobs | Remove-Job -Force
    }
    Write-Host "[Session] Kiosk launch done." -ForegroundColor Green
}

# ============================================================
#  Loop control
# ============================================================
function Start-Loop {
    if ($script:loopProcess -and -not $script:loopProcess.HasExited) {
        Write-Host "[Loop] Already running (PID $($script:loopProcess.Id))" -ForegroundColor Yellow
        return
    }
    if (Test-Path $LockFile) { Remove-Item $LockFile -Force }

    $loopScript = "$DataPath\loop.ps1"
    $enc        = $script:EncPassword
    $servers    = $script:Config.Servers -join ","
    $user       = $script:Config.User
    $url        = $script:Config.KioskUrl
    $data       = $script:Config.DataPath

    $args = "-NoExit -File `"$loopScript`"" +
            " -EncPassword `"$enc`"" +
            " -Servers `"$servers`"" +
            " -User `"$user`"" +
            " -Url `"$url`"" +
            " -Data `"$data`"" +
            " -LockFile `"$LockFile`""

    $script:loopProcess = Start-Process powershell -ArgumentList $args -PassThru
    Write-Host "[Loop] Started (PID $($script:loopProcess.Id))" -ForegroundColor Green
}

function Stop-Loop {
    if ($script:loopProcess -and -not $script:loopProcess.HasExited) {
        $script:loopProcess.Kill()
        Write-Host "[Loop] Stopped" -ForegroundColor Green
    } else {
        Write-Host "[Loop] Not running" -ForegroundColor Yellow
    }
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
    $script:loopProcess = $null
}

function Get-LoopStatus {
    if ($script:loopProcess -and -not $script:loopProcess.HasExited) {
        return "RUNNING (PID $($script:loopProcess.Id))"
    }
    return "STOPPED"
}

# ============================================================
#  Menu actions
# ============================================================
function Invoke-Action {
    param([string[]]$Items, [string]$Mode)

    $gb   = $GithubBase
    $data = "C:\Users\$($script:Config.User)\Desktop\data"

    Invoke-OnAll -Block {
        param($base, $d)
        if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
        Invoke-WebRequest "$base/server.ps1" -OutFile "$d\server.ps1" -UseBasicParsing
    } -ArgList $gb, $data

    foreach ($item in $Items) {
        switch ($item.Trim()) {
            "1" {
                Write-Host "[1] PsExec check..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Get-PsExec
                } -ArgList $data
                Write-Host "[1] Done" -ForegroundColor Green
            }
            "2" {
                Write-Host "[2] Cleanup startup items..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Clear-StartupItems
                } -ArgList $data
                Write-Host "[2] Done" -ForegroundColor Green
            }
            "3" {
                Write-Host "[3] Registering schedulers..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Register-Schedulers
                } -ArgList $data
                Write-Host "[3] Done" -ForegroundColor Green
            }
            "4" {
                Write-Host "[4] Applying permissions..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Set-Permissions
                } -ArgList $data
                Write-Host "[4] Done" -ForegroundColor Green
            }
            "5" {
                Write-Host "[5] Applying HKLM policy (mode: $Mode)..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d, $m)
                    . "$d\server.ps1"
                    Initialize-Server
                    Set-HKLMPolicy -Mode $m
                } -ArgList $data, $Mode
                Write-Host "[5] Done" -ForegroundColor Green
            }
            "6" {
                Write-Host "[6] Applying HKU policy..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Set-HKUPolicy
                } -ArgList $data
                Write-Host "[6] Done" -ForegroundColor Green
            }
            "7" {
                Write-Host "[7] Stop Chrome + clean data..." -ForegroundColor Cyan
                Invoke-OnAll -Block {
                    param($d)
                    . "$d\server.ps1"
                    Initialize-Server
                    Stop-ChromeAndClean
                } -ArgList $data
                Write-Host "[7] Done" -ForegroundColor Green
            }
            "S" { Start-Session }
            "L" { Start-Loop }
            "K" { Stop-Loop }
        }
    }
}

# ============================================================
#  Mode select
# ============================================================
function Select-Mode {
    Write-Host ""
    Write-Host "  Select class mode:" -ForegroundColor Cyan
    Write-Host "  1. Elice"
    Write-Host "  2. Entry"
    Write-Host "  3. MakeCode"
    Write-Host "  4. AppInventor"
    Write-Host "  5. Classroom"
    Write-Host ""
    $sel = Read-Host "  Mode"
    switch ($sel.Trim()) {
        "1" { return "Elice" }
        "2" { return "Entry" }
        "3" { return "MakeCode" }
        "4" { return "AppInventor" }
        "5" { return "Classroom" }
        default {
            Write-Host "  Invalid. Defaulting to Elice." -ForegroundColor Yellow
            return "Elice"
        }
    }
}

# ============================================================
#  Menu display
# ============================================================
function Show-Menu {
    param([string]$Mode)
    $loopStatus = Get-LoopStatus
    Clear-Host
    Write-Host "=============================================" -ForegroundColor DarkCyan
    Write-Host "  Lab Management Console" -ForegroundColor Cyan
    Write-Host "  Servers : $($script:Config.Servers -join ', ')" -ForegroundColor DarkGray
    Write-Host "  Mode    : $Mode" -ForegroundColor DarkGray
    Write-Host "  Loop    : $loopStatus" -ForegroundColor DarkGray
    Write-Host "=============================================" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  [1] PsExec check / download"
    Write-Host "  [2] Cleanup startup items"
    Write-Host "  [3] Register schedulers"
    Write-Host "  [4] Apply permissions (icacls)"
    Write-Host "  [5] Apply HKLM policy"
    Write-Host "  [6] Apply HKU policy"
    Write-Host ""
    Write-Host "  [7] Stop Chrome + clean data  (manual)"
    Write-Host ""
    Write-Host "  [S] Session start (explorer stop + kiosk launch)"
    Write-Host "  [L] Loop start    [K] Loop stop"
    Write-Host "  [M] Change mode   [0] Exit"
    Write-Host ""
    Write-Host "  Enter = run 1-6 / select: e.g. 1,3,5"
    Write-Host "=============================================" -ForegroundColor DarkCyan
}

# ============================================================
#  Main
# ============================================================
Initialize-Manage
Get-Cred
$currentMode = Select-Mode

while ($true) {
    Show-Menu -Mode $currentMode
    $rawInput = Read-Host "  >>"

    if ($rawInput -eq "0") {
        Stop-Loop
        Write-Host "Bye." -ForegroundColor DarkGray
        break
    }

    if ($rawInput -match "^[Mm]$") {
        $currentMode = Select-Mode
        continue
    }

    if ([string]::IsNullOrWhiteSpace($rawInput)) {
        $items = @("1","2","3","4","5","6")
    } else {
        $items = $rawInput -split '[,\s]+' | ForEach-Object { $_.Trim().ToUpper() }
    }

    Invoke-Action -Items $items -Mode $currentMode

    Write-Host ""
    Write-Host "  Press any key to return to menu..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
