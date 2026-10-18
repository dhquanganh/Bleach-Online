@echo off
chcp 65001 >nul
cd /d "%~dp0"
netstat -ano -p tcp | findstr /R /C:":7420 .*LISTENING" >nul
if errorlevel 1 start "Bleach Dosya Sunucusu" /min "%~dp0node\node.exe" "%~dp0sunucu-kok\serve.mjs" --ozel --fetch-missing
start "" http://127.0.0.1:7420/admin
exit
