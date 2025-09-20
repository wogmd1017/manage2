$zipFile = "browsinghistoryview.zip"
$destinationFolder = "C:\Users\Administrator\Desktop\Data"
$zipPath = Join-Path $destinationFolder $zipFile
$ProgressPreference = 'Continue'

# 작업 폴더 생성 (없으면 새로 만듦)
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory | Out-Null
}

Set-Location -Path $destinationFolder

# 파일 다운로드 (기존 파일 새로 덮어쓰기 - wget -N 유사 기능)
function Download-UntilSuccess($url, $outFile) {
    while ($true) {
        try {
            Invoke-WebRequest -Uri $url -OutFile $outFile -ErrorAction Stop
            if ((Test-Path $outFile) -and ((Get-Item $outFile).Length -gt 0)) {
                Write-Host "다운로드 성공: $outFile" -ForegroundColor Green
                break  # 성공하면 반복 중단
            } else {
                Write-Host "다운로드된 파일이 비어있습니다. 재시도합니다..." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
        }

        # 잠깐 대기 후 재시도 (예: 5초)
        Start-Sleep -Seconds 5
    }
}

Download-UntilSuccess "https://www.nirsoft.net/utils/browsinghistoryview.zip" "$zipPath"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting2.ps1" "$destinationFolder\cpcsetting2.ps1"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup2.ps1" "$destinationFolder\hostup2.ps1"
Download-UntilSuccess "https://raw.githubusercontent.com/wogmd1017/manage2/main/hisup2.ps1" "$destinationFolder\hisup2.ps1"

# 압축 해제 (기존 파일이 있으면 덮어쓰기)
if (Test-Path $zipPath) {
    # 먼저 기존 경로가 있으면 지움
    if (Test-Path "$destinationFolder\BrowsingHistoryView") {
        Remove-Item "$destinationFolder\BrowsingHistoryView" -Recurse -Force
    }
    Expand-Archive -Path $zipPath -DestinationPath $destinationFolder -Force
}

# 사용자 입력 대기 (pause 대체)
Write-Host "계속하려면 Enter 키를 누르세요..."
[void][System.Console]::ReadLine()

# PowerShell 스크립트 실행 (동일 콘솔, 스코프 공유)
. "$destinationFolder\cpcsetting2.ps1"
