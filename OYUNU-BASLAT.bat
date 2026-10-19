@echo off
chcp 65001 >nul
title Bleach Online - Yerel
cd /d "%~dp0"
set "NODE=%~dp0node\node.exe"
if not exist "%NODE%" (
	echo ERROR: Khong tim thay Node runtime: "%NODE%"
	pause
	exit /b 1
)
"%NODE%" -e "require.resolve('mongodb')" >nul 2>&1
if errorlevel 1 (
	echo ERROR: Thieu thu vien Node. Chay npm install trong thu muc du an, roi mo lai game.
	pause
	exit /b 1
)

echo ============================================
echo    BLEACH ONLINE - Yerel Surum
echo ============================================
echo.
echo  Dil / Language:
echo    1) English     (orijinal)
echo    2) Turkce
echo    3) Deutsch
echo    4) Francais
echo    5) Espanol
echo    6) Portugues
echo    7) Italiano
echo    8) Russkiy     (Rusca)
echo    9) Indonesia
echo    0) Tieng Viet
echo    A) Nihongo     (Japonca)
echo    B) Zhongwen    (Cince)
echo.
choice /c 1234567890AB /n /t 15 /d 1 /m "  Sec / Choose [1-9,0,A,B] (15 sn sonra English): "
set "BLEACH_DIL=en"
if errorlevel 12 set "BLEACH_DIL=zh"
if errorlevel 12 goto dilsecildi
if errorlevel 11 set "BLEACH_DIL=ja"
if errorlevel 11 goto dilsecildi
if errorlevel 10 set "BLEACH_DIL=vi"
if errorlevel 10 goto dilsecildi
if errorlevel 9 set "BLEACH_DIL=id"
if errorlevel 9 goto dilsecildi
if errorlevel 8 set "BLEACH_DIL=ru"
if errorlevel 8 goto dilsecildi
if errorlevel 7 set "BLEACH_DIL=it"
if errorlevel 7 goto dilsecildi
if errorlevel 6 set "BLEACH_DIL=pt"
if errorlevel 6 goto dilsecildi
if errorlevel 5 set "BLEACH_DIL=es"
if errorlevel 5 goto dilsecildi
if errorlevel 4 set "BLEACH_DIL=fr"
if errorlevel 4 goto dilsecildi
if errorlevel 3 set "BLEACH_DIL=de"
if errorlevel 3 goto dilsecildi
if errorlevel 2 set "BLEACH_DIL=tr"
:dilsecildi
echo.
echo  Goruntu: tam ekran acilir. F11 = tam ekran ac/kapa, Esc = cik,
echo           Ctrl+Shift+F = sigdir / orijinal boyut, F5 = yeniden giris.
set "BLEACH_TAMEKRAN=1"
echo.
echo  Sunucular baslatiliyor... (dil: %BLEACH_DIL%)
netstat -ano -p tcp | findstr /R /C:":7420 .*LISTENING" >nul
if errorlevel 1 start "Bleach Dosya Sunucusu" /min "%NODE%" "%~dp0sunucu-kok\serve.mjs" --ozel --fetch-missing
set /a WAIT_COUNT=0
:BEKLE_SUNUCULAR
netstat -ano -p tcp | findstr /R /C:":7420 .*LISTENING" >nul
if errorlevel 1 goto CHO_SUNUCULAR
netstat -ano -p tcp | findstr /R /C:":843 .*LISTENING" >nul
if errorlevel 1 goto CHO_SUNUCULAR
goto SUNUCULAR_HAZIR
:CHO_SUNUCULAR
set /a WAIT_COUNT+=1
if %WAIT_COUNT% GEQ 30 goto SUNUCU_HATA
timeout /t 1 /nobreak >nul
goto BEKLE_SUNUCULAR
:SUNUCU_HATA
echo ERROR: Node sunuculari 30 saniye icinde hazir olmadi.
echo Kiem tra cua so serve.mjs va cau hinh MongoDB trong .env.
echo Neu querySrv ECONNREFUSED: them MONGODB_DNS_SERVERS=1.1.1.1,8.8.8.8 vao .env.
pause
exit /b 1
:SUNUCULAR_HAZIR

echo  Oyun aciliyor, lutfen birkac saniye bekleyin...
echo  (Admin panel: http://127.0.0.1:7420/admin  -  ADMIN-PANEL.bat ile ac)
echo  (Oyun icinde sag ustteki "Karakter Magazasi" dugmesiyle altinla karakter alinir)
timeout /t 6 /nobreak >nul

rem --- Oyun penceresi (tam yol; uygulama klasoru = oyun\, package.json main-yerel.js) ---
"%~dp0oyun\electron.exe" "%~dp0oyun"

rem --- Oyun kapaninca arka plandaki sunuculari da kapat ---
taskkill /FI "WINDOWTITLE eq Bleach Dosya Sunucusu*" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq Bleach Oyun Sunucusu*"  /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq Bleach Admin*"          /T /F >nul 2>&1
exit
