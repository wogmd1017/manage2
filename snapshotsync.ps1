# ============================================================
#  snapshotsync.ps1 - Pull per-session screenshots off the servers
#  and onto the teacher PC, then delete the synced copies from the
#  server. Servers here can roll back / lose local state on an
#  unclean shutdown or reboot, so nothing captured should be left
#  sitting there any longer than one poll interval.
#  Launched by manage.ps1 (Start-SnapshotSync).
# ============================================================
param(
    [string]$EncPassword,
    [string]$Servers,
    [string]$User,
    [string]$RemoteDataPath,
    [string]$OutDir,
    [string]$LockFile,
    [int]$PollSeconds = 20
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

function Get-ServerId {
    param([string]$Ip)
    return "st$($Ip.Split('.')[-1])"
}

function Get-DestPath {
    # snapshot.ps1 names files yyyyMMdd_HHmmss.jpg under <owner>\ - group them
    # further into <owner>\yyyy-MM-dd\ so weeks of accumulation stay easy to
    # browse and delete a day at a time. Falls back to no date folder if a
    # filename ever doesn't match the expected pattern.
    param([string]$LocalFolder, [string]$Owner, [System.IO.FileInfo]$RemoteFile)
    if ($RemoteFile.BaseName -match '^(\d{4})(\d{2})(\d{2})_') {
        $dateTag = "$($Matches[1])-$($Matches[2])-$($Matches[3])"
        return Join-Path $LocalFolder (Join-Path $Owner (Join-Path $dateTag $RemoteFile.Name))
    }
    return Join-Path $LocalFolder (Join-Path $Owner $RemoteFile.Name)
}

try {
    while ($true) {
        foreach ($server in $svrs) {
            $remoteFolder = "$RemoteDataPath\Snapshots"
            $localFolder  = Join-Path $OutDir (Get-ServerId $server)

            try {
                $session = New-PSSession -ComputerName $server -Credential $cred -ErrorAction Stop

                $remoteFiles = Invoke-Command -Session $session -ScriptBlock {
                    param($f)
                    if (Test-Path $f) { Get-ChildItem $f -Recurse -File -Filter *.jpg }
                } -ArgumentList $remoteFolder

                if ($remoteFiles) {
                    if (-not (Test-Path $localFolder)) { New-Item -ItemType Directory -Path $localFolder -Force | Out-Null }

                    foreach ($rf in $remoteFiles) {
                        $relative = $rf.FullName.Substring($remoteFolder.Length).TrimStart('\')
                        $owner    = ($relative -split '\\')[0]
                        $destPath = Get-DestPath -LocalFolder $localFolder -Owner $owner -RemoteFile $rf
                        $destDir  = Split-Path $destPath -Parent
                        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
                        Copy-Item -FromSession $session -Path $rf.FullName -Destination $destPath -Force -ErrorAction SilentlyContinue
                    }

                    $remotePaths = $remoteFiles | ForEach-Object { $_.FullName }
                    Invoke-Command -Session $session -ScriptBlock {
                        param($paths)
                        $paths | ForEach-Object { Remove-Item $_ -Force -ErrorAction SilentlyContinue }
                    } -ArgumentList (, $remotePaths)

                    Write-Host "$(Get-Date -Format 'HH:mm:ss') [$server] synced $($remoteFiles.Count) file(s)" -ForegroundColor DarkGray
                }

                Remove-PSSession $session
            } catch {
                # Server unreachable this cycle - just retry next poll. Whatever landed on
                # the teacher PC in earlier cycles is already safe regardless.
            }
        }
        Start-Sleep -Seconds $PollSeconds
    }
} finally {
    Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
}
