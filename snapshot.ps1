# ============================================================
#  snapshot.ps1 - Per-session screenshot watcher
#  Launched (via PsExec -i <sessionId>) into a single student
#  session's own desktop. Runs indefinitely, saving a JPEG of
#  that session's screen locally on the server every -IntervalSec
#  seconds, so a reported account-swap incident can be reviewed
#  afterward at readable resolution (one seat, not a 36-way wall).
# ============================================================
param(
    [string]$Owner,
    [string]$OutDir,
    [int]$IntervalSec = 15,
    [int]$RetentionDays = 5
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$folder = Join-Path $OutDir $Owner
if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }

$lastCleanup = Get-Date

while ($true) {
    try {
        $bounds = [System.Windows.Forms.SystemInformation]::VirtualScreen
        $bmp    = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
        $g      = [System.Drawing.Graphics]::FromImage($bmp)
        $g.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)

        $file = Join-Path $folder ("{0}.jpg" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
        $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Jpeg)

        $g.Dispose()
        $bmp.Dispose()
    } catch {
        # Desktop may be momentarily unavailable (lock screen, session switch) - just retry next cycle
    }

    if (((Get-Date) - $lastCleanup).TotalHours -ge 1) {
        Get-ChildItem $folder -Filter *.jpg -ErrorAction SilentlyContinue |
            Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-$RetentionDays) } |
            Remove-Item -Force -ErrorAction SilentlyContinue
        $lastCleanup = Get-Date
    }

    Start-Sleep -Seconds $IntervalSec
}
