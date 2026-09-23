# ============================================================
#  eventcollect.ps1 - Remote System/Application event log watcher
#  Polls all servers for new Critical/Error events and saves them
#  locally on the teacher PC (per-server csv), so the history is
#  kept even if a server later goes unreachable or has to be
#  power-cycled.
#
#  Each server is checked in its own background job so one slow or
#  unreachable server doesn't delay checking the others in the same
#  cycle.
#
#  Launched by manage.ps1 (Start-EventCollector).
# ============================================================
param(
    [string]$EncPassword,
    [string]$Servers,
    [string]$User,
    [string]$OutDir,
    [string]$LockFile,
    [int]$PollSeconds = 20,
    [int]$JobTimeoutSeconds = 60
)

$ScriptVersion = "2026-09-23.1"
Write-Host "[EventCollector] eventcollect.ps1 version $ScriptVersion" -ForegroundColor Cyan

if (Test-Path $LockFile) {
    Write-Host "[EventCollector] Already running. Exit."
    Start-Sleep 2
    exit
}
New-Item $LockFile -Force | Out-Null

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }

$sec  = $EncPassword | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PSCredential($User, $sec)
$svrs = $Servers -split ","

$lastCheck      = @{}
$offline        = @{}
$offlineNotice  = @{}
$lastHeartbeat  = @{}
$now0           = Get-Date
$NoticeEvery    = [TimeSpan]::FromMinutes(5)
$HeartbeatEvery = [TimeSpan]::FromMinutes(15)
foreach ($s in $svrs) {
    $lastCheck[$s]     = $now0
    $offline[$s]       = $false
    $offlineNotice[$s] = $now0
    $lastHeartbeat[$s] = $now0
}

function Get-ServerId {
    param([string]$Ip)
    return "st$($Ip.Split('.')[-1])"
}

function Write-EventRow {
    param(
        [string]$Server, [string]$Status, [string]$LogName,
        [int]$Level, [string]$Provider, [int]$EventId,
        [string]$Message, [datetime]$Time
    )
    $sid  = Get-ServerId $Server
    $file = Join-Path $OutDir "$sid.csv"
    $row  = [PSCustomObject]@{
        Time     = $Time.ToString("yyyy-MM-dd HH:mm:ss")
        Server   = $Server
        Status   = $Status
        LogName  = $LogName
        Level    = $Level
        Provider = $Provider
        EventId  = $EventId
        Message  = ($Message -replace "`r`n", " " -replace "`n", " ")
    }
    $row | Export-Csv -Path $file -Append -NoTypeInformation -Encoding UTF8
}

# Runs entirely inside a background job (its own runspace/process), so it
# can't see anything defined outside it. Returns only plain values (never
# the raw event objects) to avoid any serialization surprises crossing back
# out of the job.
$CheckOneServer = {
    param($server, $cred, $since)

    try {
        # -FilterHashtable with both LogName and Level as arrays reliably threw a
        # Win32 "parameter is incorrect" error on these servers' event log engine,
        # even with no DateTime involved at all. Falling back to the plain -LogName
        # form (no FilterHashtable/XPath translation) and filtering Level/time
        # locally sidesteps whatever that incompatibility is.
        $events = Invoke-Command -ComputerName $server -Credential $cred -ScriptBlock {
            @('System', 'Application') | ForEach-Object {
                Get-WinEvent -LogName $_ -MaxEvents 50 -ErrorAction SilentlyContinue
            } | Where-Object { $_.Level -eq 1 -or $_.Level -eq 2 }
        } -ErrorAction Stop

        $events = $events | Where-Object { $_.TimeCreated -gt $since } | Sort-Object TimeCreated

        $flat = @()
        foreach ($e in $events) {
            $flat += [PSCustomObject]@{
                Id           = [int]$e.Id
                Level        = [int]$e.Level
                LevelDisplay = [string]$e.LevelDisplayName
                Provider     = [string]$e.ProviderName
                LogName      = [string]$e.LogName
                Message      = [string]$e.Message
                TimeCreated  = [datetime]$e.TimeCreated
            }
        }

        [PSCustomObject]@{ Server = $server; Ok = $true; Events = $flat; Error = $null }
    } catch {
        [PSCustomObject]@{ Server = $server; Ok = $false; Events = @(); Error = $_.Exception.Message }
    }
}

try {
    while ($true) {
        $jobs = foreach ($server in $svrs) {
            Start-Job -ScriptBlock $CheckOneServer -ArgumentList $server, $cred, $lastCheck[$server]
        }

        $jobs | Wait-Job -Timeout $JobTimeoutSeconds | Out-Null

        foreach ($job in $jobs) {
            $result = Receive-Job -Job $job -ErrorAction SilentlyContinue
            if (-not $result) { continue }

            $server = $result.Server
            $now    = Get-Date

            if ($result.Ok) {
                if ($offline[$server]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 복구됨" -ForegroundColor Green
                    Write-EventRow -Server $server -Status "RECOVERED" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message "서버 응답 복구" -Time $now
                    $offline[$server] = $false
                }

                if ($result.Events.Count -gt 0) {
                    foreach ($e in $result.Events) {
                        Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] EventID $($e.Id) ($($e.LevelDisplay)) $($e.Provider)" -ForegroundColor Yellow
                        Write-EventRow -Server $server -Status "EVENT" -LogName $e.LogName -Level $e.Level -Provider $e.Provider -EventId $e.Id -Message $e.Message -Time $e.TimeCreated
                    }
                    $lastCheck[$server] = ($result.Events | Measure-Object -Property TimeCreated -Maximum).Maximum.AddMilliseconds(1)
                }

                if (($now - $lastHeartbeat[$server]) -ge $HeartbeatEvery) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 정상 폴링 중" -ForegroundColor DarkGray
                    Write-EventRow -Server $server -Status "HEARTBEAT" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message "정상 폴링 중 (조용함 = 이상 없음)" -Time $now
                    $lastHeartbeat[$server] = $now
                }
            } else {
                if (-not $offline[$server]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 응답없음" -ForegroundColor Red
                    Write-EventRow -Server $server -Status "OFFLINE" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message $result.Error -Time $now
                    $offline[$server]       = $true
                    $offlineNotice[$server] = $now
                } elseif (($now - $offlineNotice[$server]) -ge $NoticeEvery) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 응답없음 (계속됨)" -ForegroundColor Red
                    Write-EventRow -Server $server -Status "STILL_OFFLINE" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message $result.Error -Time $now
                    $offlineNotice[$server] = $now
                }
            }
        }

        $jobs | Remove-Job -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds $PollSeconds
    }
} finally {
    Get-Job | Remove-Job -Force -ErrorAction SilentlyContinue
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}
