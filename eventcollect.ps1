# ============================================================
#  eventcollect.ps1 - Remote System/Application event log watcher
#  Polls all servers for new Critical/Error events and saves them
#  locally on the teacher PC (per-server csv), so the history is
#  kept even if a server later goes unreachable or has to be
#  power-cycled. Launched by manage.ps1 (Start-EventCollector).
# ============================================================
param(
    [string]$EncPassword,
    [string]$Servers,
    [string]$User,
    [string]$OutDir,
    [string]$LockFile,
    [int]$PollSeconds = 20
)

$ScriptVersion = "2026-09-16.1"
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

$lastCheck     = @{}
$offline       = @{}
$offlineNotice = @{}
$now0          = Get-Date
$NoticeEvery   = [TimeSpan]::FromMinutes(5)
foreach ($s in $svrs) { $lastCheck[$s] = $now0; $offline[$s] = $false; $offlineNotice[$s] = $now0 }

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

try {
    while ($true) {
        foreach ($server in $svrs) {
            $since = $lastCheck[$server]
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
                $events = $events | Where-Object { $_.TimeCreated -gt $since }

                if ($offline[$server]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 복구됨" -ForegroundColor Green
                    Write-EventRow -Server $server -Status "RECOVERED" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message "서버 응답 복구" -Time (Get-Date)
                    $offline[$server] = $false
                }

                if ($events) {
                    $events = $events | Sort-Object TimeCreated
                    foreach ($e in $events) {
                        Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] EventID $($e.Id) ($($e.LevelDisplayName)) $($e.ProviderName)" -ForegroundColor Yellow
                        Write-EventRow -Server $server -Status "EVENT" -LogName $e.LogName -Level $e.Level -Provider $e.ProviderName -EventId $e.Id -Message $e.Message -Time $e.TimeCreated
                    }
                    $lastCheck[$server] = ($events | Measure-Object -Property TimeCreated -Maximum).Maximum.AddMilliseconds(1)
                }
            } catch {
                $nowFail = Get-Date
                if (-not $offline[$server]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 응답없음" -ForegroundColor Red
                    Write-EventRow -Server $server -Status "OFFLINE" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message $_.Exception.Message -Time $nowFail
                    $offline[$server]       = $true
                    $offlineNotice[$server] = $nowFail
                } elseif (($nowFail - $offlineNotice[$server]) -ge $NoticeEvery) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] 응답없음 (계속됨)" -ForegroundColor Red
                    Write-EventRow -Server $server -Status "STILL_OFFLINE" -LogName "-" -Level 0 -Provider "-" -EventId 0 -Message $_.Exception.Message -Time $nowFail
                    $offlineNotice[$server] = $nowFail
                }
            }
        }
        Start-Sleep -Seconds $PollSeconds
    }
} finally {
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}
