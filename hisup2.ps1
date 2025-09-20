$basePath = "C:\Users\Administrator\Desktop\Data"

# 오늘 날짜 폴더 (yyyy-MM-dd 형태)
$today = Get-Date -Format "yyyy-MM-dd"
$todayFolder = Join-Path $basePath $today

# 날짜 폴더 없으면 새로 만듦
if (-not (Test-Path $todayFolder)) {
    New-Item -Path $todayFolder -ItemType Directory | Out-Null
}

# 서버 이름 가져오기
$serverName = $env:COMPUTERNAME   # ex: SERVER01, SERVER02, SERVER03

# 서버 이름에 따라 CSV 파일 접미사 설정
switch -Regex ($serverName) {
    "SERVER(\d+)" {
        $num = $Matches[1]
        $suffix = $num
    }
    default {
        $suffix = "XX"
    }   # 예상 밖 서버의 경우 임시 이름
}

# 결과 파일 생성
$outputFile = Join-Path $todayFolder ("st{0}.csv" -f $suffix)

# browsinghistoryview.exe 실행
$exePath = Join-Path $basePath "browsinghistoryview.exe"

if (Test-Path $exePath) {
    & $exePath /scomma $outputFile /savedirect /historysource 1 /visittimefilter type 3 /visittimefiltervalue 14
    Write-Host "히스토리 저장 완료: $outputFile"
} else {
    Write-Host "실행 파일을 찾을 수 없습니다: $exePath"
}
