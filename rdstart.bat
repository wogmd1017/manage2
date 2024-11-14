cd C:\ProgramData\Microsoft\Windows\Start Menu
rd /s /q Programs
FOR %%a in (01,02,03,04,05,06,07,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30) DO (
cd C:\Users\%%a\AppData\Local\Microsoft\Windows
rd /s /q WinX
cd C:\Users\%%a\AppData\Roaming\Microsoft\Windows\Start Menu
rd /s /q Programs
)
timeout /t 5
