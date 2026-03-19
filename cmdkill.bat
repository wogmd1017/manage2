setlocal enabledelayedexpansion
set "ADMIN_NAME=%USERNAME%"

:LOOP
taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1
taskkill /F /FI "IMAGENAME eq regedit.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1
taskkill /F /FI "IMAGENAME eq powershell.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1
taskkill /F /FI "IMAGENAME eq mspaint.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1

REM for /L %%N in (1, 1, 40) do (
REM set "ID=0%%N"
REM set "USER_ID=!ID:~-2!"
REM if exist "C:\Users\!USER_ID!\Desktop" (
REM for /d %%D in ("C:\Users\!USER_ID!\Desktop\*새 폴더*") do (
REM rd /s /q "%%D" >nul 2>&1
REM echo [ACTION] Deleted dummy folder from Student !USER_ID!
REM )
REM )
REM )

timeout /t 3 /nobreak >nul
goto :LOOP
