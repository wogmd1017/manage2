@echo off
set "zipFile=browsinghistoryview.zip"
set "destinationFolder=C:\Users\Administrator\Desktop\Data"
cd C:\Users\Administrator\Desktop\Data
wget -N https://www.nirsoft.net/utils/browsinghistoryview.zip
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.bat
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.bat
C:\Program Files\Bandizip\bandizip.exe x -y -aoa "%zipFile%" -o:"%destinationFolder%"
pause
cpcsetting1.bat
