:top
@echo off
cd c:\windows\system32
echo ====================================================================================================
echo 1. hklm for elice.io(Python)
echo 2. hklm for Hamster(Entry)
echo 3. hklm for Microbit(MakeCode)
echo 4. hklm for 1g app inventor
echo 5. hklm for 1g AI
echo 6. delete 1.
echo 7. delete 2.
echo 8. delete 3.
echo 9. delete 4.
echo 0. delete 5.
echo ====================================================================================================
set /p x=Choose work number:

if "%x%"=="1" goto 1
if "%x%"=="2" goto 2
if "%x%"=="3" goto 3
if "%x%"=="4" goto 4
if "%x%"=="5" goto 5
if "%x%"=="6" goto 6
if "%x%"=="7" goto 7
if "%x%"=="8" goto 8
if "%x%"=="9" goto 9
if "%x%"=="0" goto 0
goto top

:common
REM Logon
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "SyncForegroundPolicy" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\System" /v "DisableForceUnload" /t REG_DWORD /d 1 /f
REM prevent changing desktop background of local machine
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallPaper" /t REG_DWORD /d 1 /f
REM chrome setting
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "AllowDinosaurEasterEgg" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "AutofillAddressEnabled" /t REG_DWORD /d 0  /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BlockExternalExtensions" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserAddPersonEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserGuestModeEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "BrowserThemeColor" /t REG_SZ /d "#000000" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "DeveloperToolsAvailability" /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "DeveloperToolsDisabled" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "GoogleSearchSidePanelEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "HideWebStoreIcon" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "IncognitoModeAvailability" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NTPCustomBackgroundEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "SideSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist" /v "1" /t REG_SZ /d "*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "1" /t REG_SZ /d "chrome://settings" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "2" /t REG_SZ /d "chrome://settings/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "3" /t REG_SZ /d "chrome://history" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "4" /t REG_SZ /d "chrome://history/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "5" /t REG_SZ /d "chrome://extensions" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "6" /t REG_SZ /d "chrome://extensions/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "7" /t REG_SZ /d "chrome://flags" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "8" /t REG_SZ /d "chrome://flags/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "9" /t REG_SZ /d "chrome://signin-internals" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "10" /t REG_SZ /d "chrome://signin-internals/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "11" /t REG_SZ /d "chrome://management" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "12" /t REG_SZ /d "chrome://management/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "13" /t REG_SZ /d "chrome://net-internals" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "14" /t REG_SZ /d "chrome://net-internals/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "15" /t REG_SZ /d "chrome://chrome-urls" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "16" /t REG_SZ /d "chrome://chrome-urls/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "17" /t REG_SZ /d "chrome://device-log" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "18" /t REG_SZ /d "chrome://device-log/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "19" /t REG_SZ /d "chrome://system" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "20" /t REG_SZ /d "chrome://system/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "21" /t REG_SZ /d "chromewebstore.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "22" /t REG_SZ /d "chromewebstore.google.com/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "23" /t REG_SZ /d "ftp://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "24" /t REG_SZ /d "file://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "25" /t REG_SZ /d "data:*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "26" /t REG_SZ /d "javascript:*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "27" /t REG_SZ /d "filesystem:*" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "30" /t REG_SZ /d "chrome://*" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "31" /t REG_SZ /d "*" /f
REM reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "31" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "1" /t REG_SZ /d "chrome-untrusted://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "2" /t REG_SZ /d "chrome-extension://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "3" /t REG_SZ /d "chrome://newtab/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "4" /t REG_SZ /d "chrome://os-settings/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "5" /t REG_SZ /d "chrome://resources/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "6" /t REG_SZ /d "chrome://theme/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "7" /t REG_SZ /d "chrome://favicon/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "8" /t REG_SZ /d "chrome://user-actions/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "9" /t REG_SZ /d "chrome://version/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "10" /t REG_SZ /d "chrome://error/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "11" /t REG_SZ /d "chrome://welcome/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "12" /t REG_SZ /d "chrome://policy/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "13" /t REG_SZ /d "apis.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "14" /t REG_SZ /d "googleapis.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "15" /t REG_SZ /d "gstatic.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "16" /t REG_SZ /d "colab.research.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "17" /t REG_SZ /d "github.com/wogmd1017/class2024" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "18" /t REG_SZ /d "githubassets.com" /f
REM edge setting
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "AllowSurfGame" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "BlockExternalExtensions" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "BrowserGuestModeEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "DeveloperToolsAvailability" /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "FullscreenAllowed" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "InPrivateModeAvailability" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "NewTabPageAllowedBackgroundTypes" /t REG_DWORD /d 3 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "WebCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge" /v "WebWidgetAllowed" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLBlocklist" /v "1" /t REG_SZ /d "edge://settings" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLBlocklist" /v "2" /t REG_SZ /d "edge://history" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLBlocklist" /v "3" /t REG_SZ /d "microsoftedge.microsoft.com/addons" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLBlocklist" /v "4" /t REG_SZ /d "*" /f
REM reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge\URLBlocklist" /v "4" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "1" /t REG_SZ /d "accounts.elice.io" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "2" /t REG_SZ /d "testroom.elice.io" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "3" /t REG_SZ /d "colab.research.google.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "4" /t REG_SZ /d "googleapis.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "5" /t REG_SZ /d "gstatic.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "6" /t REG_SZ /d "github.com/wogmd1017/class2024" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "7" /t REG_SZ /d "www.onlinegdb.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "8" /t REG_SZ /d "githubassets.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "9" /t REG_SZ /d "apis.google.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "10" /t REG_SZ /d "googleusercontent.com" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "11" /t REG_SZ /d "gyeongnam-gm-m.elice.io" /f
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "12" /t REG_SZ /d "donghang-m.elice.io" /f
REM explorer setting
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main" /v "NoBrowser" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "NotifyDisableIEOptions" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v "DisableDeleteBrowsingHistory" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "CleanHistory" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d 1 /f
REM dism /online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64
REM prevent control box and desktop change
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ForceActiveDesktopOn" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktop" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoActiveDesktopChanges" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAddingComponents" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoEditingComponents" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetIcon" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoNetworkConnections" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPowerOptions" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSetTaskbar" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "showonly:" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableUserSwitch" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoSystemPage" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "NoUserAccountControl" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Uninstall" /v "NoStore" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowVPN" /v "value" /t REG_DWORD /d 0 /f
REM SRP
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "DefaultLevel" /t REG_DWORD /d 0x00040000 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "PolicyScope" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "TransparentEnabled" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v "AuthenticodeEnabled" /t REG_DWORD /d 0 /f
REM moviemk.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" /v "ItemData" /t REG_SZ /d "C:\Program Files (x86)\Windows Live\Photo Gallery\moviemk.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111111}" /v "Level" /t REG_DWORD /d 0 /f
REM mspaint.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" /v "ItemData" /t REG_SZ /d "%SystemRoot%\System32\mspaint.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111112}" /v "Level" /t REG_DWORD /d 0 /f
REM Microsoft.Photos.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" /v "ItemData" /t REG_SZ /d "%ProgramFiles%\WindowsApps\Microsoft.Windows.Photos_*\Microsoft.Photos.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111113}" /v "Level" /t REG_DWORD /d 0 /f
REM WindowsCamera.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" /v "ItemData" /t REG_SZ /d "%ProgramFiles%\WindowsApps\Microsoft.WindowsCamera_*\WindowsCamera.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111114}" /v "Level" /t REG_DWORD /d 0 /f
REM Magnify.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" /v "ItemData" /t REG_SZ /d "%SystemRoot%\System32\Magnify.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111115}" /v "Level" /t REG_DWORD /d 0 /f
REM AcroRD32.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" /v "ItemData" /t REG_SZ /d "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111116}" /v "Level" /t REG_DWORD /d 0 /f
REM Explorer.exe
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" /v "ItemData" /t REG_SZ /d "C:\Windows\explorer.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" /v "SaferFlags" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{11111111-1111-1111-1111-111111111117}" /v "Level" /t REG_DWORD /d 0 /f
REM disallowrun
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d 1 /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_MULTI_SZ /d "notepad.exe" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "iexplore.exe" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "powershell.exe" /f
REM disable hot keys
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout" /v "Scancode Map" /t REG_BINARY /d "00000000000000000300000000005BE000005CE000000000" /f
REM block installation
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Appx" /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer" /v "DisableMSI" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer" /v "AlwaysInstallElevated" /t REG_DWORD /d 1 /f
REM Disable Tray Context Menu
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayContextMenu" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewContextMenu" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer" /v "DisableContextMenusInStart" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideRunAsVerb" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartBanner" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\batfile\shell\runasuser" /v "SuppressionPolicy" /t REG_DWORD /d 4096 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\cmdfile\shell\runasuser" /v "SuppressionPolicy" /t REG_DWORD /d 4096 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\exefile\shell\runasuser" /v "SuppressionPolicy" /t REG_DWORD /d 4096 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\mscfile\shell\runasuser" /v "SuppressionPolicy" /t REG_DWORD /d 4096 /f
REM Disable file and printer sharing
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network" /v "NoFileSharing" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Network" /v "NoPrintSharing" /t REG_DWORD /d 1 /f
REM Disable powershell
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v "DisablePowerShell" /t REG_DWORD /d 1 /f
REM Disable URI
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableAppUriHandlers" /t REG_DWORD /d 0 /f
REM Disable windows ink
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f
REM Disable power button
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Start" /v "HidePowerButton" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Start" /v "HideShutDown" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HidePowerOptions" /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /d 1 /f
REM Disable Regedit
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
REM Disable USB Storage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 4 /f
REM Disable Start Menu
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\TileDataModelSvc" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMorePrograms" /d 1 /f
REM UAC enable
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
REM Disable CMD
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" /v "DisableCMD" /t REG_DWORD /d 2 /f
exit /b

:1
@echo on
call :common
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NewTabPageLocation" /t REG_SZ /d "https://gyeongnam-gm-m.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "28" /t REG_SZ /d "http://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "29" /t REG_SZ /d "https://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "19" /t REG_SZ /d "*.elice.io/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "20" /t REG_SZ /d "accounts.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "21" /t REG_SZ /d "testroom.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "22" /t REG_SZ /d "api-activity.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "23" /t REG_SZ /d "api-rest.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "24" /t REG_SZ /d "api-cms.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "25" /t REG_SZ /d "api-course.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "26" /t REG_SZ /d "gyeongnam-gm-m.elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "27" /t REG_SZ /d "googleusercontent.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "28" /t REG_SZ /d "account.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "29" /t REG_SZ /d "account.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "30" /t REG_SZ /d "accounts.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "31" /t REG_SZ /d "accounts.google.co.kr" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "32" /t REG_SZ /d "www.onlinegdb.com" /f
gpupdate /force
set N5=1
exit /b

:2
@echo on
call :common
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "28" /t REG_SZ /d "http://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "29" /t REG_SZ /d "https://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "19" /t REG_SZ /d "account.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "20" /t REG_SZ /d "account.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "21" /t REG_SZ /d "accounts.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "22" /t REG_SZ /d "accounts.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "23" /t REG_SZ /d "googleusercontent.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "24" /t REG_SZ /d "http://playentry.org/" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "25" /t REG_SZ /d "https://playentry.org/" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "26" /t REG_SZ /d "http://playentry.org/*" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "27" /t REG_SZ /d "https://playentry.org/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "30" /t REG_SZ /d "http://playentry.org/project" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "31" /t REG_SZ /d "https://playentry.org/project" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "32" /t REG_SZ /d "http://playentry.org/project/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "33" /t REG_SZ /d "https://playentry.org/project/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "34" /t REG_SZ /d "http://playentry.org/project*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "35" /t REG_SZ /d "https://playentry.org/project*" /f
gpupdate /force
set N5=2
exit /b

:3
@echo on
call :common
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "28" /t REG_SZ /d "http://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "29" /t REG_SZ /d "https://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "19" /t REG_SZ /d "account.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "20" /t REG_SZ /d "account.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "21" /t REG_SZ /d "accounts.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "22" /t REG_SZ /d "accounts.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "23" /t REG_SZ /d "googleusercontent.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "24" /t REG_SZ /d "makecode.microbit.org" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "25" /t REG_SZ /d "http://makecode.microbit.org" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "26" /t REG_SZ /d "https://makecode.microbit.org" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "27" /t REG_SZ /d "http://makecode.microbit.org/*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "28" /t REG_SZ /d "https://makecode.microbit.org/*" /f
gpupdate /force
set N5=3
exit /b

:4
@echo on
call :common
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NewTabPageLocation" /t REG_SZ /d "https://appinventor.mit.edu" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "28" /t REG_SZ /d "http://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "29" /t REG_SZ /d "https://*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "19" /t REG_SZ /d "account.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "20" /t REG_SZ /d "account.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "21" /t REG_SZ /d "accounts.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "22" /t REG_SZ /d "accounts.google.co.kr" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "23" /t REG_SZ /d "googleusercontent.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "24" /t REG_SZ /d "appinventor.mit.edu" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "25" /t REG_SZ /d "mywaycoding.tistory.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "26" /t REG_SZ /d "mywaycoding.tistory.com/*" /f
gpupdate /force
set N5=4
exit /b

:5
@echo on
call :common
gpupdate /force
set N5=5
exit /b

:6
@echo on
call :common
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NewTabPageLocation" /f
for %%i in (28 29) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "%%i" /f
)
for /L %%i in (19,1,32) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "%%i" /f
)
gpupdate /force
set N5=6
exit /b

:7
@echo on
call :common
for /L %%i in (28,1,29) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "%%i" /f
)
for /L %%i in (19,1,35) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "%%i" /f
)
gpupdate /force
set N5=7
exit /b

:8
@echo on
call :common
for /L %%i in (28,1,29) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "%%i" /f
)
for /L %%i in (19,1,28) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "%%i" /f
)
gpupdate /force
set N5=8
exit /b

:9
@echo on
call :common
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NewTabPageLocation" /f
for %%i in (28 29) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "%%i" /f
)
for /L %%i in (19,1,26) do (
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "%%i" /f
)
gpupdate /force
set N5=9
exit /b

:0
@echo on
call :common
gpupdate /force
set N5=0
exit /b

