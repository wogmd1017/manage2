$zipFile = "browsinghistoryview.zip"
$destinationFolder = "C:\Users\Administrator\Desktop\Data"
$zipPath = Join-Path $destinationFolder $zipFile

# 작업 폴더 생성 (없으면 새로 만듦)
if (-not (Test-Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory | Out-Null
}

Set-Location -Path $destinationFolder

# 파일 다운로드 (기존 파일 새로 덮어쓰기 - wget -N 유사 기능)
Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/browsinghistoryview.zip" -OutFile $zipPath -UseBasicParsing
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.bat" -OutFile "cpcsetting1.bat" -UseBasicParsing
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.bat" -OutFile "hostup.bat" -UseBasicParsing

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

# BAT 파일 실행 (PowerShell에서 직접 실행 가능)
Start-Process "cpcsetting1.ps1" -Wait
