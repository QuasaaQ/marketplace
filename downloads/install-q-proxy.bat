@echo off
setlocal
chcp 65001 >nul
title Install q-proxy for Chrome and Yandex Browser
echo ============================================================
echo   Extension installer
echo   Package : q-proxy
echo   Version : 1.7
echo   ID      : aafcbgdepfbaicngmbeknofmllehbmmk
echo ============================================================
echo.
echo  What this file does:
echo    1. downloads the extension file from the marketplace site
echo    2. registers it through the HKCU keys of the browser
echo    3. you restart the browser and confirm the extension once
echo.
echo  RUN THIS FILE AS ADMINISTRATOR: without administrator rights the
echo  registry step fails and the extension is not installed.
echo  The only way without administrator rights is the beta build of
echo  Yandex Browser: drag the downloaded .crx into its window.
echo.
echo  To uninstall later, run this file with the word:  remove
echo.
pause

set "PKG=q-proxy"
set "VER=1.7"
set "ID=aafcbgdepfbaicngmbeknofmllehbmmk"
set "CRX_DIR=%LOCALAPPDATA%\Q.Marketplace"
set "CRX_FILE=%CRX_DIR%\%PKG%.crx"
set "CRX_URL=https://quasaaq.github.io/marketplace/downloads/q-proxy.crx"

if /i "%~1"=="remove" goto remove

echo [1/3] Downloading the extension file...
if not exist "%CRX_DIR%" mkdir "%CRX_DIR%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '%CRX_URL%' -OutFile '%CRX_FILE%' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 goto dl_failed
if not exist "%CRX_FILE%" goto dl_failed
echo [OK] %CRX_FILE%
echo.

echo [2/3] Registering for Chrome and Yandex Browser...
reg add "HKCU\Software\Yandex\YandexBrowser\Extensions\%ID%" /v path    /t REG_SZ /d "%CRX_FILE%" /f >nul
reg add "HKCU\Software\Yandex\YandexBrowser\Extensions\%ID%" /v version /t REG_SZ /d "%VER%"     /f >nul
reg add "HKCU\Software\Google\Chrome\Extensions\%ID%"         /v path    /t REG_SZ /d "%CRX_FILE%" /f >nul
reg add "HKCU\Software\Google\Chrome\Extensions\%ID%"         /v version /t REG_SZ /d "%VER%"     /f >nul
if errorlevel 1 goto reg_failed
echo [OK]
echo.

echo [3/3] Done. Next steps:
echo    1. Close ALL browser windows and the tray icon.
echo    2. Start the browser again.
echo    3. Open browser://extensions (Yandex) or chrome://extensions (Chrome)
echo       and press the confirm button for this extension once.
echo.
echo  Further updates arrive automatically, no need to run this file again.
echo ============================================================
pause
exit /b 0

:dl_failed
echo.
echo [ERROR] Could not download the extension file.
echo [INFO]  Check the internet connection and run this file again.
echo [INFO]  Without administrator rights only the beta build of Yandex
echo [INFO]  Browser works: drag the downloaded .crx into browser://tune.
echo.
pause
exit /b 1

:reg_failed
echo.
echo [ERROR] Could not write the registry keys.
echo [INFO]  Right-click this file and choose "Run as administrator".
echo.
pause
exit /b 1

:remove
reg delete "HKCU\Software\Yandex\YandexBrowser\Extensions\%ID%" /f >nul 2>&1
reg delete "HKCU\Software\Google\Chrome\Extensions\%ID%" /f >nul 2>&1
if exist "%CRX_FILE%" del /f /q "%CRX_FILE%" >nul
echo Removed. Restart the browser and the extension will be uninstalled.
echo.
pause
exit /b 0