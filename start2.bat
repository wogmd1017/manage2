@echo off
:: 관리자 권한 확인 & 자동 상승
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 관리자 권한이 필요합니다. UAC 권한 상승을 요청합니다...
    PowerShell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 관리자 권한으로 PowerShell 실행 (작업 끝나면 창 닫힘)
PowerShell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Administrator\Desktop\Data\start2.ps1"
exit
