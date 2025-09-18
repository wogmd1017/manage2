<# 
 start1.ps1
 - 교사PC Data 폴더 준비 & 최신 cpcsetting1.ps1 다운로드
 - 각 서버 Data 폴더에 필요한 exe/ps1 전부 다운로드 & 압축해제
 - 완료 후 교사PC에서 cpcsetting1.ps1 실행
#>

param(
    [string[]]$Computers = @("Server1","Server2","Server3")
)

$ErrorActionPreference = "Stop"

# =========================
# 1. 교사PC 작업 폴더 준비
# =========================
$LocalDestination = "C:\Users\Administrator\Desktop\Data"

if (-not (Test-Path $LocalDestination)) {
    New-Item -Path $LocalDestination -ItemType Directory | Out-Null
    Write-Host "교사PC: [$LocalDestination] 폴더 생성"
} else {
    Write-Host "교사PC: [$LocalDestination] 폴더 이미 존재"
}

# 교사PC에 메뉴 스크립트 확보
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.ps1" `
                  -OutFile "$LocalDestination\cpcsetting1.ps1" -UseBasicParsing
Write-Host "교사PC: cpcsetting1.ps1 다운로드 완료"

# =========================
# 2. 서버 리소스 준비 (Remoting)
# =========================
$serverScript = {
    param($Destination)

    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory | Out-Null
        Write-Host "[$env:COMPUTERNAME] Data 폴더 생성"
    } else {
        Write-Host "[$env:COMPUTERNAME] Data 폴더 이미 존재"
    }

    Write-Host "[$env:COMPUTERNAME] NirSoft ZIP 다운로드"
    Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/browsinghistoryview.zip" `
                      -OutFile "$Destination\browsinghistoryview.zip" -UseBasicParsing

    Write-Host "[$env:COMPUTERNAME] hostup.ps1/hisup.ps1/hku1.ps1/hklm1.ps1 다운로드"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.ps1" `
                      -OutFile "$Destination\hostup.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hisup.ps1" `
                      -OutFile "$Destination\hisup.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hku1.ps1" `
                      -OutFile "$Destination\hku1.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm1.ps1" `
                      -OutFile "$Destination\hklm1.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/start2.ps1" `
                      -OutFile "$Destination\hklm1.ps1" -UseBasicParsing
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting2.ps1" `
                      -OutFile "$Destination\hklm1.ps1" -UseBasicParsing
                      
    Write-Host "[$env:COMPUTERNAME] ZIP 압축 해제 중..."
    Expand-Archive -Path "$Destination\browsinghistoryview.zip" -DestinationPath $Destination -Force

    Write-Host "[$env:COMPUTERNAME] Data 세팅 완료"
}

Invoke-Command -ComputerName $Computers -ScriptBlock $serverScript -ArgumentList "C:\Users\Administrator\Desktop\Data"

# =========================
# 3. 교사PC에서 메뉴 실행
# =========================
Write-Host "모든 준비 완료 → cpcsetting1.ps1 실행으로 넘어갑니다."
& "$LocalDestination\cpcsetting1.ps1"
