# ============================================================
#  snapshotsync.ps1 - Pull per-session screenshots off the servers
#  and onto the teacher PC, then delete the synced copies from the
#  server. Servers here can roll back / lose local state on an
#  unclean shutdown or reboot, so nothing captured should be left
#  sitting there any longer than one poll interval.
#
#  Each server is synced in its own background job so a large
#  backlog on one server doesn't delay the others - they all run
#  at once instead of one after another.
#
#  Launched by manage.ps1 (Start-SnapshotSync).
# ============================================================
param(
    [string]$EncPassword,
    [string]$Servers,
    [string]$User,
    [string]$RemoteDataPath,
    [string]$OutDir,
    [string]$LockFile,
    [int]$PollSeconds = 20,
    [int]$JobTimeoutSeconds = 180
)

if (Test-Path $LockFile) {
    Write-Host "[SnapshotSync] Already running. Exit."
    Start-Sleep 2
    exit
}
New-Item $LockFile -Force | Out-Null

if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir -Force | Out-Null }

$sec  = $EncPassword | ConvertTo-SecureString
$cred = New-Object System.Management.Automation.PSCredential($User, $sec)
$svrs = $Servers -split ","

$offline      = @{}
$offlineSince = @{}
$NoticeEvery  = [TimeSpan]::FromMinutes(5)
foreach ($s in $svrs) { $offline[$s] = $false }

# Runs entirely inside a background job (its own runspace), so it can't see
# any function/variable defined outside it - everything it needs is either
# passed in as an argument or defined again right here.
$SyncOneServer = {
    param($server, $cred, $remoteDataPath, $localOutDir)

    function Get-ServerId {
        param([string]$Ip)
        return "st$($Ip.Split('.')[-1])"
    }

    function Get-DestPath {
        # $RemoteFile is intentionally untyped: it crosses the Invoke-Command
        # remoting boundary as a Deserialized.System.IO.FileInfo, not a real
        # FileInfo, and a [System.IO.FileInfo]-typed parameter threw a type
        # conversion error on every call. Property access (.BaseName, .Name)
        # works the same either way.
        param([string]$LocalFolder, [string]$Owner, $RemoteFile)
        if ($RemoteFile.BaseName -match '^(\d{4})(\d{2})(\d{2})_') {
            $dateTag = "$($Matches[1])-$($Matches[2])-$($Matches[3])"
            return Join-Path $LocalFolder (Join-Path $Owner (Join-Path $dateTag $RemoteFile.Name))
        }
        return Join-Path $LocalFolder (Join-Path $Owner $RemoteFile.Name)
    }

    $remoteFolder = "$remoteDataPath\Snapshots"
    $localFolder  = Join-Path $localOutDir (Get-ServerId $server)

    try {
        $session = New-PSSession -ComputerName $server -Credential $cred -ErrorAction Stop

        $remoteFiles = Invoke-Command -Session $session -ScriptBlock {
            param($f)
            if (Test-Path $f) { Get-ChildItem $f -Recurse -File -Filter *.jpg }
        } -ArgumentList $remoteFolder -ErrorAction Stop

        $count = 0
        if ($remoteFiles) {
            if (-not (Test-Path $localFolder)) { New-Item -ItemType Directory -Path $localFolder -Force | Out-Null }

            foreach ($rf in $remoteFiles) {
                $relative = $rf.FullName.Substring($remoteFolder.Length).TrimStart('\')
                $owner    = ($relative -split '\\')[0]
                $destPath = Get-DestPath -LocalFolder $localFolder -Owner $owner -RemoteFile $rf
                $destDir  = Split-Path $destPath -Parent
                if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
                Copy-Item -FromSession $session -Path $rf.FullName -Destination $destPath -Force -ErrorAction SilentlyContinue
                $count++
            }

            $remotePaths = $remoteFiles | ForEach-Object { $_.FullName }
            Invoke-Command -Session $session -ScriptBlock {
                param($paths)
                $paths | ForEach-Object { Remove-Item $_ -Force -ErrorAction SilentlyContinue }
            } -ArgumentList (, $remotePaths)
        }

        Remove-PSSession $session
        [PSCustomObject]@{ Server = $server; Ok = $true; Count = $count; Error = $null }
    } catch {
        [PSCustomObject]@{ Server = $server; Ok = $false; Count = 0; Error = $_.Exception.Message }
    }
}

try {
    while ($true) {
        $jobs = foreach ($server in $svrs) {
            Start-Job -ScriptBlock $SyncOneServer -ArgumentList $server, $cred, $RemoteDataPath, $OutDir
        }

        $jobs | Wait-Job -Timeout $JobTimeoutSeconds | Out-Null

        foreach ($job in $jobs) {
            $result = Receive-Job -Job $job -ErrorAction SilentlyContinue
            if (-not $result) { continue }

            $srv = $result.Server
            $now = Get-Date

            if ($result.Ok) {
                if ($offline[$srv]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$srv] 복구됨" -ForegroundColor Green
                    $offline[$srv] = $false
                }
                if ($result.Count -gt 0) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$srv] synced $($result.Count) file(s)" -ForegroundColor DarkGray
                }
            } else {
                if (-not $offline[$srv]) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$srv] sync 실패: $($result.Error)" -ForegroundColor Red
                    $offline[$srv]      = $true
                    $offlineSince[$srv] = $now
                } elseif (($now - $offlineSince[$srv]) -ge $NoticeEvery) {
                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$srv] sync 실패 (계속됨): $($result.Error)" -ForegroundColor Red
                    $offlineSince[$srv] = $now
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
