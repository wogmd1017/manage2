$S = "10.65.167.11", "10.65.167.12", "10.65.167.13", "10.65.167.14"
$user = "manager"
$secpasswd = Read-Host -Prompt "$user, Enter Password." -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential($user, $secpasswd)
$url = "https://boonpo-m.elice.io"

# ============================
# 0단계: PsExec 다운로드
# ============================
Write-Host "PsExec 확인 중..." -ForegroundColor Cyan
Invoke-Command -ComputerName $S -Credential $cred -ScriptBlock {
    $psexec = "C:\Users\Administrator\Desktop\data\PsExec.exe"
    $wget   = "C:\Users\Administrator\Desktop\data\wget.exe"
    if (Test-Path $psexec) {
        Write-Host "[$(hostname)] PsExec 있음" -ForegroundColor Gray
    } else {
        Write-Host "[$(hostname)] PsExec 다운로드 중..." -ForegroundColor Yellow
        & $wget -N "https://live.sysinternals.com/PsExec.exe" -O $psexec 2>$null
        if (Test-Path $psexec) {
            Write-Host "[$(hostname)] 다운로드 완료" -ForegroundColor Green
        } else {
            Write-Host "[$(hostname)] 다운로드 실패!" -ForegroundColor Red
        }
    }
}

# ============================
# 세션 파싱 함수
# ============================
function Get-StudentSessions {
    Invoke-Command -ComputerName $S -Credential $cred -ScriptBlock {
        (query session 2>$null) | Select-Object -Skip 1 |
            ForEach-Object {
                if ($_ -match '^\s+(\S+)\s+(\d+)\s+(디스크|Disc|Active|활성)') {
                    [PSCustomObject]@{
                        User      = $matches[1]
                        SessionId = $matches[2]
                    }
                }
            } | Where-Object {
                $_.User -notin @('manager', 'Administrator') -and
                $_.SessionId -match '^\d+$'
            }
    }
}

# ============================
# 1단계: explorer 종료
# ============================
Write-Host "`nexplorer 종료 중..." -ForegroundColor Cyan
Invoke-Command -ComputerName $S -Credential $cred -ScriptBlock {
    Set-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" `
        -Name "AutoRestartShell" -Value 0 -Type DWord

    Get-WmiObject Win32_Process -Filter "Name='explorer.exe'" |
        ForEach-Object {
            $owner = $_.GetOwner().User
            if ($owner -notin @('Administrator', 'manager')) {
                $_.Terminate() | Out-Null
                Write-Host "[$(hostname)][$owner] explorer 종료" -ForegroundColor Yellow
            }
        }
}

Write-Host "3초 대기..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# ============================
# 2단계: 세션 확인 + 키오스크 초기 실행
# ============================
Write-Host "세션 목록 확인 중..." -ForegroundColor Cyan
$initSessions = Get-StudentSessions

if ($initSessions) {
    Write-Host "감지된 세션 $($initSessions.Count)개:" -ForegroundColor Cyan
    $initSessions | ForEach-Object {
        Write-Host "  → [$($_.PSComputerName)][$($_.User)] 세션 $($_.SessionId)" `
            -ForegroundColor Gray
    }
} else {
    Write-Host "감지된 세션 없음! query session 파싱 확인 필요" -ForegroundColor Red
}

# 서버별로 그룹핑 후 병렬 실행
$sessionsByServer = $initSessions | Group-Object PSComputerName

$initJobs = foreach ($serverGroup in $sessionsByServer) {
    $serverIP = $serverGroup.Name

    # PSCustomObject → 해시테이블로 변환 (직렬화 안전)
    $sessionData = $serverGroup.Group | ForEach-Object {
        @{
            User      = $_.User
            SessionId = $_.SessionId
        }
    }

    Start-Job -ScriptBlock {
        param($serverIP, $cred, $sessionData, $url)
        Invoke-Command -ComputerName $serverIP -Credential $cred -ScriptBlock {
            param($sessionData, $url)
            $chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
            $psexec = "C:\Users\Administrator\Desktop\data\PsExec.exe"

            foreach ($session in $sessionData) {
                $sid     = [int]$session.SessionId
                $owner   = $session.User
                $profile = "$env:APPDATA\Local\Google\Chrome\User Data\Session_$sid"
                $bat     = "C:\Windows\Temp\kiosk_$sid.bat"

                Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                    Where-Object { $_.SessionId -eq $sid } |
                    ForEach-Object { $_.Terminate() | Out-Null }

                Start-Sleep -Milliseconds 500

                $content = "@echo off`r`n" +
                           "`"$chrome`" --kiosk $url --no-first-run " +
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
							"--kiosk-printing"

                [System.IO.File]::WriteAllText(
                    $bat, $content, [System.Text.Encoding]::ASCII)

                Write-Host "[$env:COMPUTERNAME][$owner] 세션 $sid 키오스크 실행"
                & $psexec -accepteula -i $sid -s cmd /c $bat 2>&1
            }
        } -ArgumentList $sessionData, $url
    } -ArgumentList $serverIP, $cred, $sessionData, $url
}

if ($initJobs) {
    $initJobs | Wait-Job -Timeout 60 | Out-Null
    $initJobs | Remove-Job -Force
}

Write-Host "`n초기 실행 완료! 감시 루프 진입 (Ctrl+C로 종료)`n" -ForegroundColor Cyan

# ============================
# 3단계: 감시 루프
# ============================
$lastLaunch = @{}

try {
    while ($true) {
        $now = Get-Date

        $allSessions = Invoke-Command -ComputerName $S -Credential $cred -ScriptBlock {
            $sessions = (query session 2>$null) | Select-Object -Skip 1 |
                ForEach-Object {
                    if ($_ -match '^\s+(\S+)\s+(\d+)\s+(디스크|Disc|Active|활성)') {
                        [PSCustomObject]@{
                            User      = $matches[1]
                            SessionId = $matches[2]
                        }
                    }
                } | Where-Object {
                    $_.User -notin @('manager', 'Administrator') -and
                    $_.SessionId -match '^\d+$'
                }

            foreach ($s in $sessions) {
                $sid = [int]$s.SessionId
                $kioskRunning = [bool](
                    Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                    Where-Object {
                        $_.SessionId -eq $sid -and
                        $_.CommandLine -like "*--kiosk*"
                    }
                )
                [PSCustomObject]@{
                    User         = $s.User
                    SessionId    = $sid
                    KioskRunning = $kioskRunning
                }
            }
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

            if ($lastLaunch[$key] -and
                ($now - $lastLaunch[$key]).TotalSeconds -lt 10) {
                continue
            }

            Write-Host "$(Get-Date -Format 'HH:mm:ss') [$serverIP][$owner] 세션 $sid 재실행" `
                -ForegroundColor Yellow
            $lastLaunch[$key] = $now

            Start-Job -ScriptBlock {
                param($serverIP, $cred, $sid, $url)
                Invoke-Command -ComputerName $serverIP -Credential $cred -ScriptBlock {
                    param($sid, $url)
                    $chrome  = "C:\Program Files\Google\Chrome\Application\chrome.exe"
                    $psexec  = "C:\Users\Administrator\Desktop\data\PsExec.exe"
                    $profile = "C:\Windows\Temp\ChromeKiosk_$sid"
                    $bat     = "C:\Windows\Temp\kiosk_$sid.bat"

                    Get-WmiObject Win32_Process -Filter "Name='chrome.exe'" |
                        Where-Object { $_.SessionId -eq $sid } |
                        ForEach-Object { $_.Terminate() | Out-Null }

                    Start-Sleep -Milliseconds 500

                    $content = "@echo off`r`n" +
                               "`"$chrome`" --kiosk $url --no-first-run --bwsi " +
                               "--disable-sync --user-data-dir=`"$profile`" " +
                               "--disable-pinch --overscroll-history-navigation=0 " +
                               "--noerrdialogs --disable-session-crashed-bubble " +
                               "--kiosk-printing"

                    [System.IO.File]::WriteAllText(
                        $bat, $content, [System.Text.Encoding]::ASCII)

                    & $psexec -accepteula -i $sid -s cmd /c $bat 2>&1

                } -ArgumentList $sid, $url
            } -ArgumentList $serverIP, $cred, $sid, $url | Out-Null
        }

        Get-Job -State Completed | Remove-Job
        Get-Job -State Failed    | Remove-Job

        if ($allOk) {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') 전체 정상" `
                -ForegroundColor Green
        }

        Start-Sleep -Seconds 3
    }
}
finally {
    Get-Job | Remove-Job -Force
}