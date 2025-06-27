@echo off
set A1=0
set A2=0
set A3=0
set A4=0
set A5=0
set A6=0
set A7=0

:top
@echo off
cd c:\windows\system32
echo ====================================================================================================
echo ---Before run : Uninstall V3---
echo 1. Delete Start App lists, %A1% times runed!
echo 2. Desktop deny setting, %A2% times runed!
echo 3. Schedule start, %A3% times runed!
echo 4. HKU resitry setting, %A4% times runed!
echo 5. HKLM resitry setting for elice.io, %A5% times runed!
echo 6. HKLM resitry setting for 1g app inventor, %A6% times runed!
echo 7. HKLM resitry setting for 1g AI, %A7% times runed!
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
FOR %%b in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30) DO (
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
FOR %%c in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30) DO (
ICACLS C:\Users\%%c /t /deny %%c:W
ICACLS C:\Users\%%c\Desktop /grant %%c:RX /deny %%c:W
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
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hku1.bat
call hku1.bat
pause
@echo off
set /a A4+=1
goto top

:5
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm1.bat
call hklm1.bat
pause
@echo off
set /a A5+=1
goto top

:6
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm2.bat
call hklm2.bat
pause
@echo off
set /a A6+=1
goto top

:7
@echo on
cd C:\Users\Administrator\Desktop\Data
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hklm3.bat
call hklm3.bat
pause
@echo off
set /a A7+=1
goto top
