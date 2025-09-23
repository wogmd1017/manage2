# 실행 횟수 저장 변수
$A1 = 0
$A2 = 0
$A3 = 0
$A4 = 0
$A5 = 0
$N5 = 0
$ProgressPreference = 'Continue'
$VerbosePreference = "Continue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download 함수 정의
function Download-AndRun($url, $outFile) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $outFile -ErrorAction Stop `
            -Headers @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
        Write-Host "Down Success: $outFile" -ForegroundColor Green
    }
    catch {
        Write-Host "Down Fail: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host "Press Enter to go Menu"
        return
    }

    if (-not (Test-Path $outFile) -or (Get-Item $outFile).Length -eq 0) {
        Write-Host "Empty File!" -ForegroundColor Red
        Read-Host "Press Enter to go Menu"
        return
    }

    . $outFile
}

function Show-Menu {
    Clear-Host
    Write-Host "===================================================================================================="
    Write-Host "--- Before run : Uninstall V3 ---"
    Write-Host "1. Delete Start App lists, $A1 times runned!"
    Write-Host "2. Desktop deny setting, $A2 times runned!"
    Write-Host "3. Schedule start, $A3 times runned!"
    Write-Host "4. HKU registry setting, $A4 times runned!"
    Write-Host "5. HKLM registry setting, ($N5), $A5 times runned!"
    Write-Host "0. !!Exit!!"
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
                Remove-Item "C:\Users\$u\AppData\Local\Microsoft\Windows\WinX" -Recurse -Force -ErrorAction SilentlyContinue -Verbose
                Remove-Item "C:\Users\$u\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" -Recurse -Force -ErrorAction SilentlyContinue
            }

            Read-Host "Press Enter to continue..."
            $A1++
        }

        "2" {
            # Desktop deny setting
            $ComputerName = $env:COMPUTERNAME
            $users = 01..30 | ForEach-Object { "{0:D2}" -f $_ }
            foreach ($u in $users) {
                $account = "$ComputerName\$u"
                icacls "C:\Users\$u" /t /deny "$account:(W)"
                icacls "C:\Users\$u\Desktop" /grant "$account:(RX)" /deny "$account:(W)"
            }

            Read-Host "Press Enter to continue..."
            $A2++
        }

        "3" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"

            #schtasks /create /tn "hostup" /tr "powershell.exe -ExecutionPolicy Bypass -File `"$dataPath\hostup2.ps1`"" /sc minute /F
            #schtasks /create /tn "hisup" /tr "powershell.exe -ExecutionPolicy Bypass -File `"$dataPath\hisup2.ps1`"" /sc minute /F

            # hostup 작업 등록
            $actionHostup   = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$dataPath\hostup2.ps1`""
            $triggerHostup  = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1)
            $triggerHostup.RepetitionInterval = (New-TimeSpan -Minutes 1)
            $triggerHostup.RepetitionDuration = (New-TimeSpan)
            $principalHostup = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

            Register-ScheduledTask -TaskName "hostup" -Action $actionHostup -Trigger $triggerHostup -Principal $principalHostup -Force


            # hisup 작업 등록
            $actionHisup   = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$dataPath\hisup2.ps1`""
            $triggerHisup  = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1)
            $triggerHisup.RepetitionInterval = (New-TimeSpan -Minutes 1)
            $triggerHisup.RepetitionDuration = (New-TimeSpan)
            $principalHisup = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

            Register-ScheduledTask -TaskName "hisup" -Action $actionHisup -Trigger $triggerHisup -Principal $principalHisup -Force
            
            Read-Host "Press Enter to continue..."
            $A3++
        }

        "4" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"
            $dstFile = Join-Path $dataPath "hku2.ps1"
            #Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hku2.ps1" -OutFile $dstFile -UseBasicParsing
            Download-AndRun "https://raw.githubusercontent.com/wogmd1017/manage2/main/hku2.ps1" $dstFile

            Read-Host "Press Enter to continue..."
            $A4++
        }

        "5" {
            $dataPath = "C:\Users\Administrator\Desktop\Data"
            $dstFile = Join-Path $dataPath "hklm2.ps1"
            #Invoke-WebRequest -Uri "https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm2.ps1" -OutFile $dstFile -UseBasicParsing
            Download-AndRun "https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm2.ps1" $dstFile

            Read-Host "Press Enter to continue..."
            $A5++
        }
        "0" { break }

        default {
            Write-Host "Wrong Input. Try Again."
            Start-Sleep -Seconds 1
        }
    }
}
