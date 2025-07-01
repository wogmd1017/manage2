@echo off
set "zipFile=browsinghistoryview.zip"
set "destinationFolder=C:\Users\Administrator\Desktop\Data"
cd C:\Users\Administrator\Desktop\Data
wget -N --no-check-certificate https://www.nirsoft.net/utils/browsinghistoryview.zip
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.bat
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.bat
bandizip.exe x -y -aoa "%zipFile%"
pause
cpcsetting1.bat
