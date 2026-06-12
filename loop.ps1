# ============================================================
#  loop.ps1 - Kiosk watchdog loop (launched by manage.ps1)
# ============================================================
param(
    [string]$EncPassword,
    [string]$Servers,
    [string]$User,
    [string]$Url,
    [string]$Data,
    [string]$LockFile
)

if (Test-Path $LockFile) {
    Write-Host "[Loop] Already running. Exit."
    Start-Sleep 2
    exit
}
New-Item $LockFile -Force | Out-Null

$sec        = $EncPassword | ConvertTo-SecureString
$cred       = New-Object System.Management.Automation.PSCredential($User, $sec)
$svrs       = $Servers -split ","
$lastLaunch = @{}

try {
    while ($true) {
        $now = Get-Date

        $allSessions = Invoke-Command -ComputerName $svrs -Credential $cred -ScriptBlock {
            (query session 2>$null) | Select-Object -Skip 1 | ForEach-Object {
                if ($_ -match '^\s+(\S+)\s+(\d+)\s+(Active|Disc|활성|디스크)') {
                    $s   = [PSCustomObject]@{ User = $matches[1]; SessionId = $matches[2] }
                    $sid = [int]$s.SessionId

                    $chromeProcs = Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                        Where-Object { $_.SessionId -eq $sid }
                    $count = ($chromeProcs | Measure-Object).Count

                    if ($count -gt 20) {
                        $chromeProcs | ForEach-Object {
                            Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
                        }
                        [PSCustomObject]@{ User = $s.User; SessionId = $sid; KioskRunning = $false }
                        return
                    }

                    $kioskRunning = [bool]($chromeProcs | Where-Object { $_.CommandLine -like '*--kiosk*' })
                    [PSCustomObject]@{ User = $s.User; SessionId = $sid; KioskRunning = $kioskRunning }
                }
            } | Where-Object {
                $_ -and
                $_.User -notin @('Administrator', $using:User) -and
                $_.SessionId -match '^\d+$'
            }
        } -ErrorAction SilentlyContinue

        # Debug: session count
        Write-Host "$(Get-Date -Format 'HH:mm:ss') Sessions: $($allSessions.Count)" -ForegroundColor Cyan
        foreach ($dbg in $allSessions) {
            Write-Host "  -> [$($dbg.PSComputerName)][$($dbg.User)] sid $($dbg.SessionId) kiosk=$($dbg.KioskRunning)" -ForegroundColor DarkCyan
        }

        $allOk = $true

        foreach ($session in $allSessions) {
            $serverIP = $session.PSComputerName
            $sid      = $session.SessionId
            $owner    = $session.User
            $key      = "${serverIP}_${sid}"

            if ($session.KioskRunning) {
                $lastLaunch[$key] = $null
                continue
            }

            $allOk = $false

            if ($lastLaunch[$key] -and ($now - $lastLaunch[$key]).TotalSeconds -lt 10) {
                continue
            }

            Write-Host "$(Get-Date -Format 'HH:mm:ss') [$serverIP][$owner] sid $sid restart" -ForegroundColor Yellow
            $lastLaunch[$key] = $now

            Start-Job -ScriptBlock {
                param($serverIP, $cred, $sid, $owner, $url, $data)
                Invoke-Command -ComputerName $serverIP -Credential $cred -ScriptBlock {
                    param($sid, $owner, $url, $data)

                    $chrome = (Get-Item `
                        "C:\Program Files\Google\Chrome\Application\chrome.exe",
                        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" `
                        -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
                    $psexec  = "$data\PsExec.exe"
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
                    & $psexec -accepteula -i $sid -s cmd /c $bat 2>&1

                } -ArgumentList $sid, $owner, $url, $data
            } -ArgumentList $serverIP, $cred, $sid, $owner, $Url, $Data | Out-Null
        }

        Get-Job -State Completed | Remove-Job
        Get-Job -State Failed    | Remove-Job

        if ($allOk) {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') All OK" -ForegroundColor Green
        }

        Start-Sleep 3
    }
} finally {
    Get-Job | Remove-Job -Force
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}
