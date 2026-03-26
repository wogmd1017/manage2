@echo on
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
powershell -Command "Start-Process '%~0' -Verb RunAs"
exit /b
)
pushd "%CD%"
cd /d "%~dp0"

@echo off
set A1=0
set A2=0
set A3=0
set A4=0
set A5=0
set A6=0
set N5=0

:top
@echo off
cd c:\windows\system32
echo ====================================================================================================
echo ---Before run : Uninstall V3---
echo 1. Delete Start App lists, %A1% times runed!
echo 2. Desktop deny setting, %A2% times runed!
echo 3. Schedule start, %A3% times runed!
echo 4. HKLM resitry setting, (%N5%), %A4% times runed!
echo 5. HKU resitry setting, %A5% times runed!
echo 6. CMDKill, %A6% times runed!
echo ====================================================================================================
set /p x=Choose work number:

goto %x%

:1
@echo on
ICACLS C:\Windows\System32\mspaint.exe /setowner Administrator /C
ICACLS C:\Windows\System32\mspaint.exe /grant Administrator:F /C
ICACLS C:\Windows\System32\SnippingTool.exe /setowner Administrator /C
ICACLS C:\Windows\System32\SnippingTool.exe /grant Administrator:F /C
del C:\Windows\System32\mspaint.exe
del C:\Windows\System32\SnippingTool.exe
cd C:\ProgramData\Microsoft\Windows\Start Menu
rd /s /q Programs
FOR %%b in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
cd C:\Users\%%b\AppData\Local\Microsoft\Windows
rd /s /q WinX
cd C:\Users\%%b\AppData\Roaming\Microsoft\Windows\Start Menu
rd /s /q Programs
)
pause
@echo off
set /a A1+=1
goto top

:2
@echo on
FOR %%c in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
ICACLS "C:\Users\%%c" /c /deny "%%c:W"
ICACLS "C:\Users\%%c\Desktop" /grant "%%c:RX" /deny "%%c:W" /c
)

FOR %%c in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
ICACLS "C:\Program Files" /deny "%%c:(OI)(CI)(X)" /c /l /q
ICACLS "C:\Program Files (x86)" /deny "%%c:(OI)(CI)(X)" /c /l /q
ICACLS "C:\ProgramData" /deny "%%c:(OI)(CI)(X)" /c /l /q
ICACLS "C:\Entry" /deny "%%c:(OI)(CI)(X)" /c /l /q
ICACLS "C:\Entry_HW" /deny "%%c:(OI)(CI)(X)" /c /l /q
)

FOR %%c in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
ICACLS "C:\Program Files\Google\Chrome\Application\chrome.exe" /grant "%%c:(RX)" /c
ICACLS "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" /grant "%%c:(RX)" /c
)

pause
@echo off
set /a A2+=1
goto top

:3
@echo on
schtasks /create /tn "hostup" /tr C:\Users\Administrator\Desktop\data\hostup.bat /sc minute
schtasks /create /tn "hisup" /tr C:\Users\Administrator\Desktop\data\hisup.bat /sc minute
pause
@echo off
set /a A3+=1
goto top

:4
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm1.bat
call hklm1.bat
pause
@echo off
set /a A4+=1
goto top

:5
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hku1.bat
call hku1.bat
pause
@echo off
set /a A5+=1
goto top

:6
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cmdkill.bat
start "CMD_WATCHER" cmdkill.bat
@echo off
set /a A6+=1
pause
goto top
