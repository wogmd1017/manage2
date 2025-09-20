# 실행 횟수 저장 변수
$A1 = 0
$A2 = 0
$A3 = 0
$A4 = 0
$A5 = 0
$N5 = 0

function Show-Menu {
    Clear-Host
    Write-Host "===================================================================================================="
    Write-Host "--- Before run : Uninstall V3 ---"
    Write-Host "1. Delete Start App lists, $A1 times runned!"
    Write-Host "2. Desktop deny setting, $A2 times runned!"
    Write-Host "3. Schedule start, $A3 times runned!"
    Write-Host "4. HKU registry setting, $A4 times runned!"
    Write-Host "5. HKLM registry setting, ($N5), $A5 times runned!"
    Write-Host "===================================================================================================="
    $choice = Read-Host "Choose work number"
    return $choice
}

while ($true) {
    $choice = Show-Menu
    switch ($choice) {

        "1" {
            # Delete Start App lists
            icacls "C:\Windows\System32\mspaint.exe" /setowner Administrator /C
            icacls "C:\Windows\System32\mspaint.exe" /grant Administrator:F /C
            icacls "C:\Windows\System32\SnippingTool.exe" /setowner Administrator /C
            icacls "C:\Windows\System32\SnippingTool.exe" /grant Administrator:F /C

            Remove-Item "C:\Windows\System32\mspaint.exe" -Force -ErrorAction SilentlyContinue
            Remove-Item "C:\Windows\System32\SnippingTool.exe" -Force -ErrorAction SilentlyContinue

            Remove-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -Force -ErrorAction SilentlyContinue

            $users = 01..30 | ForEach-Object { "{0:D2}" -f $_ }
            #$users = Get-ChildItem "C:\Users" -Directory | Where-Object { $_.Name -match '^\d{2}$' } | Select-Object -ExpandProperty Name
            foreach ($u in $users) {
                Remove-Item "C:\Users\$u\AppData\Local\Microsoft\Windows\WinX" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item "C:\Users\$u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" -Recurse -Force -ErrorAction SilentlyContinue
            }

            Read-Host "계속하려면 Enter를 누르세요..."
            $A1++
        }

        "2" {
            # Desktop deny setting
            $users = 01..30 | ForEach-Object { "{0:D2}" -f $_ }
            foreach ($u in $users) {
                icacls "C:\Users\$u" /t /deny "$u":W
                icacls "C:\Users\$u\Desktop" /grant "$u":RX /deny "$u":W
            }

            Read-Host "계속하려면 Enter를 누르세요..."
            $A2++
        }

        "3" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"

            schtasks /create /tn "hostup" /tr "powershell.exe -ExecutionPolicy Bypass -File `"$dataPath\hostup2.ps1`"" /sc minute /F
            schtasks /create /tn "hisup" /tr "powershell.exe -ExecutionPolicy Bypass -File `"$dataPath\hisup2.ps1`"" /sc minute /F
            
            Read-Host "계속하려면 Enter를 누르세요..."
            $A3++
        }

        "4" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"
            $dstFile = Join-Path $dataPath "hku2.ps1"
            #Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hku2.ps1" -OutFile $dstFile -UseBasicParsing
            try {
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hku2.ps1" -OutFile $dstFile -ErrorAction Stop
                Write-Host "다운로드 성공: $dstFile" -ForegroundColor Green
            }
            catch {
                Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
                continue
            }
            if (-not (Test-Path $dstFile) -or (Get-Item $dstFile).Length -eq 0) {
                Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
            }
            
            . $dstFile

            Read-Host "계속하려면 Enter를 누르세요..."
            $A4++
        }

        "5" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"
            $dstFile = Join-Path $dataPath "hklm2.ps1"
            #Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm2.ps1" -OutFile $dstFile -UseBasicParsing
            try {
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm2.ps1" -OutFile $dstFile -ErrorAction Stop
                Write-Host "다운로드 성공: $dstFile" -ForegroundColor Green
            }
            catch {
                Write-Host "다운로드 실패: $($_.Exception.Message)" -ForegroundColor Red
                continue
            }
            
            if (-not (Test-Path $dstFile) -or (Get-Item $dstFile).Length -eq 0) {
                Write-Host "다운로드된 파일이 없거나 비어있습니다!" -ForegroundColor Red
            }
            
            . $dstFile
            
            Read-Host "계속하려면 Enter를 누르세요..."
            $A5++
        }

        default {
            Write-Host "잘못된 입력입니다. 다시 시도하세요."
            Start-Sleep -Seconds 1
        }
    }
}
