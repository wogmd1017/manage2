CD c:\windows\system32
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
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "GoogleSearchSidePanelEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "HideWebStoreIcon" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "IncognitoModeAvailability" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "NTPCustomBackgroundEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" /v "SideSearchEnabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist" /v "1" /t REG_SZ /d "*" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "1" /t REG_SZ /d "chrome://settings" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "2" /t REG_SZ /d "chrome://history" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "3" /t REG_SZ /d "chromewebstore.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "4" /t REG_SZ /d "*" /f
REM reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLBlocklist" /v "4" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "1" /t REG_SZ /d "elice.io" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "2" /t REG_SZ /d "colab.research.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "3" /t REG_SZ /d "googleapis.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "4" /t REG_SZ /d "gstatic.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "5" /t REG_SZ /d "github.com/wogmd1017/class2024" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "6" /t REG_SZ /d "www.onlinegdb.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "7" /t REG_SZ /d "githubassets.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "8" /t REG_SZ /d "apis.google.com" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\URLAllowlist" /v "9" /t REG_SZ /d "googleusercontent.com" /f
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
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "1" /t REG_SZ /d "elice.io" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "2" /t REG_SZ /d "colab.research.google.com" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "3" /t REG_SZ /d "github.com/wogmd1017/class2024" /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\URLAllowlist" /v "4" /t REG_SZ /d "www.onlinegdb.com" /f
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
REM disallowrun
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d 1 /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_MULTI_SZ /d "notepad.exe" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "iexplore.exe" /f
REM reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "2" /t REG_MULTI_SZ /d "powershell.exe" /f
REM block installation
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Appx" /v "BlockNonAdminUserInstall" /t REG_DWORD /d 2 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer" /v "DisableMSI" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Installer" /v "AlwaysInstallElevated" /t REG_DWORD /d 1 /f
REM Disable powershell
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v "DisablePowerShell" /t REG_DWORD /d 1 /f
REM Disable URI
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableAppUriHandlers" /t REG_DWORD /d 0 /f
REM Disable windows ink
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d 0 /f
REM Disable CMD
REM reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" /v "DisableCMD" /t REG_DWORD /d 2 /f
REM Disable Regedit
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
REM Disable USB Storage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" /v "Start" /t REG_DWORD /d 4 /f
REM UAC enable
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 1 /f
gpupdate /force
