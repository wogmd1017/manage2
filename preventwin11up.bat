CD c:\windows\system32
REM prevent upgrade win11
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseversion /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseversionInfo" /t REG_SZ /d "21H2" /f
