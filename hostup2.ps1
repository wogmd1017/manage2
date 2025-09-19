$path = "C:\Windows\System32\drivers\etc\hosts"
$url  = "https://raw.githubusercontent.com/wogmd1017/manage2/main/hosts"

Write-Host "hosts 파일을 업데이트합니다..."

# 최신 파일 다운로드 및 덮어쓰기 (-N에 해당)
Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing -ErrorAction Stop

Write-Host "업데이트 완료: $path"
