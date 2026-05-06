@echo on
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
powershell -Command "Start-Process '%~0' -Verb RunAs"
exit /b
)
pushd "%CD%"
cd /d "%~dp0"

setlocal enabledelayedexpansion

@echo off
set A1=0
set A2=0
set A3=0
set A4=0
set A5=0
set A6=0
set A7=0
set N5=0

:top
@echo off
cd c:\windows\system32
echo ====================================================================================================
echo ---Before run : Uninstall V3---
echo 1. Delete Start App lists, %A1% times runed!
echo 2. Schedule start, %A2% times runed!
echo 3. HKLM resitry setting, (%N5%), %A3% times runed!
echo 4. HKU resitry setting, %A4% times runed!
echo 5. Desktop deny setting, %A5% times runed!
echo 6. Kill Chrome and Auto-Logoff Policy, %A6% times runed!
echo 7. CMDKill, %A7% times runed!
echo ====================================================================================================
set /p x=Choose work number:

goto %x%

:1
@echo on
icacls C:\Windows\System32\mspaint.exe /setowner Administrator /C
icacls C:\Windows\System32\mspaint.exe /grant Administrator:F /C
icacls C:\Windows\System32\SnippingTool.exe /setowner Administrator /C
icacls C:\Windows\System32\SnippingTool.exe /grant Administrator:F /C
del C:\Windows\System32\mspaint.exe
del C:\Windows\System32\SnippingTool.exe
set "TARGET_DIR=C:\Users\Public\Desktop"
del /q /s "%TARGET_DIR%\*.*"
for /d %%p in ("%TARGET_DIR%\*") do rd /s /q "%%p"
cd C:\ProgramData\Microsoft\Windows\Start Menu
rd /s /q Programs
FOR %%b in (01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
cd C:\Users\%%b\AppData\Local\Microsoft\Windows
rd /s /q WinX
cd C:\Users\%%b\AppData\Roaming\Microsoft\Windows\Start Menu
rd /s /q Programs
)
REM cd C:\Users\Public\Pictures\
REM curl -L "https://raw.githubusercontent.com/wogmd1017/manage2/main/wall1.png" -o "C:\Users\Public\Pictures\wall1.png" --create-dirs
REM cd C:\Users\Public
REM curl -L "https://github.com/MScholtes/VirtualDesktop/releases/download/V1.21/VirtualDesktopServer2016.exe" -o "C:\Users\Public\VirtualDesktopServer2016.exe" --create-dirs
REM curl -L "https://raw.githubusercontent.com/wogmd1017/manage2/refs/heads/main/vd.bat" -o "C:\Users\Public\vd.bat" --create-dirs
pause
@echo off
set /a A1+=1
goto top

:2
@echo on
schtasks /create /tn "hostup" /tr C:\Users\Administrator\Desktop\data\hostup.bat /sc minute /rl highest /f
schtasks /create /tn "hisup" /tr C:\Users\Administrator\Desktop\data\hisup.bat /sc minute /mo 3 /rl highest /f
cd C:\Users\Administrator\Desktop\Data
call hostup.bat
cd C:\Users\Administrator\Desktop\Data
start "" "hisup.bat"
pause
@echo off
set /a A2+=1
goto top

:3
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm1.bat
call hklm1.bat
pause
@echo off
set /a A3+=1
goto top

:4
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hku1.bat
call hku1.bat
pause
@echo off
set /a A4+=1
goto top

:5
@echo on
icacls "C:\Program Files" /inheritance:e /c /l /q
icacls "C:\Program Files (x86)" /inheritance:e /c /l /q

FOR %%c in (01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
icacls "C:\Users\%%c" /c /deny "%%c:W"
icacls "C:\Users\%%c\Desktop" /grant "%%c:RX" /deny "%%c:W" /c
)

FOR %%c in (01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
icacls "C:\Program Files" /deny "%%c:(OI)(CI)(X)" /c /l /q
icacls "C:\Program Files (x86)" /deny "%%c:(OI)(CI)(X)" /c /l /q
icacls "C:\ProgramData" /deny "%%c:(OI)(CI)(X)" /c /l /q
icacls "C:\Entry" /deny "%%c:(OI)(CI)(X)" /c /l /q
icacls "C:\Entry_HW" /deny "%%c:(OI)(CI)(X)" /c /l /q
)

FOR %%c in (01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
icacls "C:\Program Files\Google\Chrome\Application\chrome.exe" /grant "%%c:(RX)" /c
icacls "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" /grant "%%c:(RX)" /c
)

pause
@echo off
set /a A5+=1
goto top


:6
@echo on
taskkill /F /IM chrome.exe /T >nul 2>&1
taskkill /F /IM mspaint.exe /T >nul 2>&1
taskkill /F /IM hwp.exe /T >nul 2>&1
taskkill /F /IM HncTT.exe /T >nul 2>&1
taskkill /F /IM ODTEditor.exe /T >nul 2>&1
taskkill /F /IM Hword.exe /T >nul 2>&1
taskkill /F /IM excel.exe /T >nul 2>&1
taskkill /F /IM winword.exe /T >nul 2>&1
taskkill /F /IM powerpnt.exe /T >nul 2>&1
taskkill /F /IM wordpad.exe /T >nul 2>&1
taskkill /F /IM mspub.exe /T >nul 2>&1
taskkill /F /IM msaccess.exe /T >nul 2>&1
taskkill /F /IM onenote.exe /T >nul 2>&1
taskkill /F /IM ms-teams.exe /T >nul 2>&1
taskkill /F /IM Teams.exe /T >nul 2>&1
taskkill /F /IM TeamsInstaller.exe /T >nul 2>&1
taskkill /F /IM zoom.exe /T >nul 2>&1
taskkill /F /IM notepad.exe /T >nul 2>&1
taskkill /F /IM "Scratch Desktop.exe" /T >nul 2>&1
taskkill /F /IM "Scratch 3.exe" /T >nul 2>&1
taskkill /F /IM Entry.exe /T >nul 2>&1
taskkill /F /IM Entry_HW.exe /T >nul 2>&1
taskkill /F /IM CodingSchool3.exe /T >nul 2>&1
taskkill /F /IM module matcher.exe /T >nul 2>&1
taskkill /F /IM arduino.exe /T >nul 2>&1
taskkill /F /IM code.exe /T >nul 2>&1

timeout /t 3 /nobreak >nul

FOR %%u in (01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40) DO (
set "USER_DATA=C:\Users\%%u\AppData\Local\Google\Chrome\User Data"
    
if exist "!USER_DATA!" (

del /q /f "!USER_DATA!\Local State" >nul 2>&1
del /q /f "!USER_DATA!\Last Version" >nul 2>&1
del /q /f "!USER_DATA!\Last Tabs" >nul 2>&1

for /d %%p in ("!USER_DATA!\*") do (

if exist "%%p\Cookies" (
                
del /q /f "%%p\Cookies" >nul 2>&1
del /q /f "%%p\Network\Cookies" >nul 2>&1
del /q /f "%%p\Last Tabs" >nul 2>&1
del /q /f "%%p\Last Session" >nul 2>&1
rd /s /q "%%p\Sessions" >nul 2>&1
rd /s /q "%%p\Session Storage" >nul 2>&1
)
)
)
)

@echo off
set /a A6+=1
pause
goto top

:7
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cmdkill.bat
start "CMD_WATCHER" cmdkill.bat
@echo off
set /a A7+=1
pause
goto top
