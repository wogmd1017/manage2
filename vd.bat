set "VD_EXE=C:\Users\Public\VirtualDesktopServer2016.exe"

:loop
for /f "tokens=*" %%i in ('%VD_EXE% /Count') do set count=%%i
if %count% GTR 1 (
    %VD_EXE% /Switch:0
    %VD_EXE% /RemoveAll
)
timeout /t 10 >nul
goto loop
