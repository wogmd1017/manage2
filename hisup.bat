@echo off
setlocal enabledelayedexpansion

:: ============================================================
::  hisup.bat - Collect browsing history and upload to GDrive
:: ============================================================

:: Auto SERVER_ID from last IP octet (skip loopback / APIPA)
set "LAST_OCTET="
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /r "IPv4"') do (
    set "RAW=%%a"
    set "RAW=!RAW: =!"
    echo !RAW! | findstr /v "^127\." | findstr /v "^169\.254\." > nul
    if !errorlevel! equ 0 (
        for /f "tokens=4 delims=." %%b in ("!RAW!") do set "LAST_OCTET=%%b"
    )
)
if "!LAST_OCTET!"=="" (
    echo [ERROR] Could not detect IP. Using fallback ID.
    set "SERVER_ID=st00"
) else (
    set "SERVER_ID=st!LAST_OCTET!"
)

:: Paths
set "MY_DIR=%~dp0"
set "RCLONE_EXE=%MY_DIR%rclone.exe"
set "RCLONE_CONF=%MY_DIR%rclone.conf"
set "BHV_EXE=%MY_DIR%browsinghistoryview.exe"

:: Date / Time
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "dt=%%a"
set "YEAR=%dt:~0,4%"
set "MONTH=%dt:~4,2%"
set "DAY=%dt:~6,2%"
set "DATE_STR=%YEAR%%MONTH%%DAY%"
set "YEAR_LOG_DIR=%YEAR%_Log"
set "CUR_TIME=%time:~0,2%%time:~3,2%"
set "CUR_TIME=%CUR_TIME: =0%"

:: Period detection
if %CUR_TIME% LSS 0945 ( set "PRD=P1"    ) else ^
if %CUR_TIME% LSS 1040 ( set "PRD=P2"    ) else ^
if %CUR_TIME% LSS 1135 ( set "PRD=P3"    ) else ^
if %CUR_TIME% LSS 1230 ( set "PRD=P4"    ) else ^
if %CUR_TIME% LSS 1330 ( set "PRD=Lunch" ) else ^
if %CUR_TIME% LSS 1415 ( set "PRD=P5"    ) else ^
if %CUR_TIME% LSS 1510 ( set "PRD=P6"    ) else ^
if %CUR_TIME% LSS 1605 ( set "PRD=P7"    ) else ^
( set "PRD=After" )

:: Output
set "FILE_NAME=%DATE_STR%_%SERVER_ID%_%PRD%.csv"
set "LOCAL_SAVE_PATH=%MY_DIR%%YEAR_LOG_DIR%"
if not exist "%LOCAL_SAVE_PATH%" md "%LOCAL_SAVE_PATH%"

:: Collect history
"%BHV_EXE%" /scomma "%LOCAL_SAVE_PATH%\%FILE_NAME%" /savedirect /historysource 1 /visittimefilter type 3 /visittimefiltervalue 14

:: Upload via rclone
if exist "%RCLONE_CONF%" (
    "%RCLONE_EXE%" --config "%RCLONE_CONF%" copyto "%LOCAL_SAVE_PATH%\%FILE_NAME%" "gdrive:/data/%YEAR_LOG_DIR%/%FILE_NAME%" --update -v --log-file="%MY_DIR%rclone_log.txt"
    if !errorlevel! equ 0 (
        echo [SUCCESS] Upload completed: %FILE_NAME%
    ) else (
        echo [FAIL] Upload failed. Check rclone_log.txt
    )
) else (
    echo [ERROR] rclone.conf not found in %MY_DIR%
)

timeout /t 3
exit
