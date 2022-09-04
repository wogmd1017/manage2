# manage
This project is to manage 30 classroom computers(Win10 Home ver.) easily.
1. Modify 30 computers' hosts file automatically by update.bat file(wget.exe), task scheduler and github
2. Disable app installing by gpedit.msc or regedit.exe
3. Prohibit access to control panel by gpedit.msc or regedit.exe
4. Prohibit installing VPN from browsers addon by hosts file, inbuilt firewall, regedit.exe, gpedit.msc


1. Modify hosts file
  Teacher edits hosts file on github
  Logon Admin account
  Download wget.exe from https://eternallybored.org/misc/wget/
  Copy wget.exe to c:\windows\system32
  Copy update.bat to c:\windows\system32
  Use Task Scheduler trigger computer start and every 10min or teacher's favorite time
  Use Task Scheduler run update.bat with admin account and highest
  Be careful some anti-virus program reset your hosts file if it is modified!
