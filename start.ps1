Set-ExecutionPolicy RemoteSigned -Scope Process
cd desktop\data
Invoke-WebRequest "https://raw.githubusercontent.com/wogmd1017/manage2/main/manage.ps1" -OutFile ".\manage.ps1" -UseBasicParsing
Unblock-File .\manage.ps1
.\manage.ps1
