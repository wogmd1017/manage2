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
#Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/browsinghistoryview.zip" -OutFile $zipPath -UseBasicParsing
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting2.ps1" -OutFile "cpcsetting2.ps1" -UseBasicParsing
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup2.ps1" -OutFile "hostup2.ps1" -UseBasicParsing

# browsinghistoryview down
try {
    Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/browsinghistoryview.zip" -OutFile $zipPath -ErrorAction Stop
    Write-Host "다운로드 성공: $zipPath" -ForegroundColor Green
}
catch {
    Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다"
    continue
}
if (-not (Test-Path $zipPath) -or (Get-Item $zipPath).Length -eq 0) {
    Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
}
#cpcsetting down
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting2.ps1" -OutFile "cpcsetting2.ps1" -ErrorAction Stop
    Write-Host "다운로드 성공: cpcsetting2.ps1" -ForegroundColor Green
}
catch {
    Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다"
    continue
}
if (-not (Test-Path "cpcsetting2.ps1") -or (Get-Item "cpcsetting2.ps1").Length -eq 0) {
    Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
}
#hostup down
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup2.ps1" -OutFile "hostup2.ps1" -ErrorAction Stop
    Write-Host "다운로드 성공: hostup2.ps1" -ForegroundColor Green
}
catch {
    Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다"
    continue
}
if (-not (Test-Path "hostup2.ps1") -or (Get-Item "hostup2.ps1").Length -eq 0) {
    Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
}
#hisup down
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hisup2.ps1" -OutFile "hisup2.ps1" -ErrorAction Stop
    Write-Host "다운로드 성공: hisup2.ps1" -ForegroundColor Green
}
catch {
    Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Enter를 누르면 메뉴로 돌아갑니다"
    continue
}
if (-not (Test-Path "hisup2.ps1") -or (Get-Item "hisup2.ps1").Length -eq 0) {
    Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
}


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
