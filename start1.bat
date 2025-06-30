@echo off
set "zipFile=browsinghistoryview.zip"
set "destinationFolder=C:\Users\Administrator\Desktop\Data"
cd C:\Users\Administrator\Desktop\Data
wget -N https://www.nirsoft.net/utils/browsinghistoryview.zip
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.bat
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.bat
bandizip.exe x -y -aoa "%zipFile%"
cd C:\Users\Administrator\Desktop\Data
pause
cpcsetting1.bat
