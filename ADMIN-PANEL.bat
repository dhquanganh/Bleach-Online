@echo off
chcp 65001 >nul
title Bleach Admin Panel
cd /d "%~dp0"
set "NODE=%~dp0node\node.exe"
if not exist "%NODE%" (
	echo ERROR: Khong tim thay Node runtime: "%NODE%"
	pause
	exit /b 1
)
netstat -ano -p tcp | findstr /R /C:":7421 .*LISTENING" >nul
if errorlevel 1 start "Bleach Admin" /min "%NODE%" "%~dp0sunucu-kok\sunucu\admin.js"
set /a WAIT_COUNT=0
:BEKLE_ADMIN
netstat -ano -p tcp | findstr /R /C:":7421 .*LISTENING" >nul
if not errorlevel 1 goto ADMIN_HAZIR
set /a WAIT_COUNT+=1
if %WAIT_COUNT% GEQ 15 (
	echo ERROR: Admin Node server 15 saniye icinde 7421 portunda baslamadi.
	pause
	exit /b 1
)
timeout /t 1 /nobreak >nul
goto BEKLE_ADMIN
:ADMIN_HAZIR
echo Admin panel aciliyor: http://127.0.0.1:7421
start "" http://127.0.0.1:7421
exit
