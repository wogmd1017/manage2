@echo off
:: Administrator privilege check & auto elevation
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator access needed. UAC elevation required...
    PowerShell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Run PowerShell with Administrator
PowerShell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\Users\Administrator\Desktop\Data\start2.ps1""' -Verb RunAs"
exit
