@echo off
setlocal enabledelayedexpansion

set "SERVER_ID=st01"
set "MY_DIR=%~dp0"
set "RCLONE_EXE=%MY_DIR%rclone.exe"
set "RCLONE_CONF=%MY_DIR%rclone.conf"
set "BHV_EXE=%MY_DIR%browsinghistoryview.exe"

for /f "tokens=1-3 delims=- " %%a in ('echo %date%') do (
    set "YEAR=%%a"
    set "MONTH=%%b"
    set "DAY=%%c"
)
set "DATE_STR=%YEAR%%MONTH%%DAY%"
set "YEAR_LOG_DIR=%YEAR%_Log"

set "CUR_TIME=%time:~0,2%%time:~3,2%"
set "CUR_TIME=%CUR_TIME: =0%"

if %CUR_TIME% LSS 0955 ( set "PRD=P1" ) else ^
if %CUR_TIME% LSS 1050 ( set "PRD=P2" ) else ^
if %CUR_TIME% LSS 1145 ( set "PRD=P3" ) else ^
if %CUR_TIME% LSS 1330 ( set "PRD=P4" ) else ^
if %CUR_TIME% LSS 1425 ( set "PRD=P5" ) else ^
if %CUR_TIME% LSS 1520 ( set "PRD=P6" ) else ^
if %CUR_TIME% LSS 1615 ( set "PRD=P7" ) else ^
( set "PRD=After" )

set "FILE_NAME=%DATE_STR%_%SERVER_ID%_%PRD%.csv"
set "LOCAL_SAVE_PATH=%MY_DIR%%YEAR_LOG_DIR%"

if not exist "%LOCAL_SAVE_PATH%" md "%LOCAL_SAVE_PATH%"

"%BHV_EXE%" /scomma "%LOCAL_SAVE_PATH%\%FILE_NAME%" /savedirect /historysource 1 /visittimefilter type 3 /visittimefiltervalue 14

if exist "%RCLONE_CONF%" (
    "%RCLONE_EXE%" --config "%RCLONE_CONF%" copy "%LOCAL_SAVE_PATH%" "gdrive:/data/%YEAR_LOG_DIR%" --include "%FILE_NAME%" --update
    if %errorlevel% equ 0 (
    )
) else (
    echo [ERROR] rclone.conf missing in %MY_DIR%
)

timeout /t 3
exit
