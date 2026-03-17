setlocal enabledelayedexpansion
set "ADMIN_NAME=%USERNAME%"

:LOOP
taskkill /F /FI "IMAGENAME eq cmd.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1
taskkill /F /FI "IMAGENAME eq regedit.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1
taskkill /F /FI "IMAGENAME eq powershell.exe" /FI "USERNAME ne %ADMIN_NAME%" /T >nul 2>&1

//for /L %%N in (1, 1, 40) do (
//    set "ID=0%%N"
//    set "USER_ID=!ID:~-2!"
//    :: 바탕화면 경로 (서버 환경에 따라 C:\Users\!USER_ID!\Desktop 확인 필요)
//    if exist "C:\Users\!USER_ID!\Desktop" (
//        for /d %%D in ("C:\Users\!USER_ID!\Desktop\*새 폴더*") do (
//            rd /s /q "%%D" >nul 2>&1
//            echo [ACTION] Deleted dummy folder from Student !USER_ID!
//        )
//    )
//)

timeout /t 3 /nobreak >nul
goto :LOOP
