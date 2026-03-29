@echo off
set "bhvZip=browsinghistoryview.zip"
set "rcZip=rclone.zip"
set "destDir=C:\Users\Administrator\Desktop\Data"
cd /d "%destDir%"
wget -N --no-check-certificate https://www.nirsoft.net/utils/browsinghistoryview.zip
wget -N --no-check-certificate https://downloads.rclone.org/v1.73.3/rclone-v1.73.3-windows-amd64.zip -O %rcZip%
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/cpcsetting1.bat
wget -N https://raw.githubusercontent.com/wogmd1017/manage2/main/hostup.bat
bandizip.exe x -y -aoa "%bhvZip%"
bandizip.exe x -y -aoa -target:name "%rcZip%"
move /y "rclone-v1.73.3-windows-amd64\rclone.exe" .
rd /s /q "rclone-v1.73.3-windows-amd64"
del /q "%bhvZip%"
del /q "%rcZip%"
pause
cpcsetting1.bat
