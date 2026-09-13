@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Install section action
echo ============================================================
echo   Section installer
echo   Section    : action
echo   Extensions : 4
echo ============================================================
echo.
echo  What this file does:
echo    1. downloads every extension of the section from the site
echo    2. registers them for the current Windows user only
echo       (administrator rights are NOT required)
echo    3. you restart the browser and confirm the extensions once
echo.
echo  To uninstall the whole section, run this file with:  remove
echo.
pause

set "CRX_DIR=%LOCALAPPDATA%\Q.Marketplace"
set "COUNT=4"
set "OK_COUNT=0"
set "P1_PKG=a-motivac"
set "P1_VER=1.2"
set "P1_ID=fdopdiehcmjhmgmeojageodobmmphngh"
set "P1_URL=https://quasaaq.github.io/marketplace/downloads/a-motivac.crx"
set "P2_PKG=a-motivac-grey"
set "P2_VER=1.2"
set "P2_ID=ckmfnfafacifdnkhijaidbbknlneogdj"
set "P2_URL=https://quasaaq.github.io/marketplace/downloads/a-motivac-grey.crx"
set "P3_PKG=a-oplat-grey"
set "P3_VER=1.1"
set "P3_ID=menapjdenagdpanhbnbpgmhodpbkpmao"
set "P3_URL=https://quasaaq.github.io/marketplace/downloads/a-oplat-grey.crx"
set "P4_PKG=a-oplat"
set "P4_VER=1.1"
set "P4_ID=eglhcjgniigdanednhkaiakkjcpodkfg"
set "P4_URL=https://quasaaq.github.io/marketplace/downloads/a-oplat.crx"

if /i "%~1"=="remove" goto remove_all

for /l %%i in (1,1,%COUNT%) do call :install_one %%i

echo.
echo [OK] Installed !OK_COUNT! of %COUNT%.
echo.
echo [3/3] Done. Next steps:
echo    1. Close ALL browser windows and the tray icon.
echo    2. Start the browser again.
echo    3. Open browser://extensions (Yandex) or chrome://extensions (Chrome)
echo       and press the confirm button for every new extension once.
echo.
echo  Further updates arrive automatically, no need to run this file again.
echo ============================================================
pause
exit /b 0

:install_one
set "PKG=!P%1_PKG!"
set "VER=!P%1_VER!"
set "ID=!P%1_ID!"
set "URL=!P%1_URL!"
set "CRX_FILE=%CRX_DIR%\!PKG!.crx"
echo.
echo [i] Installing !PKG! !VER!
if not exist "%CRX_DIR%" mkdir "%CRX_DIR%"
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '!URL!' -OutFile '!CRX_FILE!' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 goto one_failed
if not exist "!CRX_FILE!" goto one_failed
reg add "HKCU\Software\Yandex\YandexBrowser\Extensions\!ID!" /v path    /t REG_SZ /d "!CRX_FILE!" /f >nul
reg add "HKCU\Software\Yandex\YandexBrowser\Extensions\!ID!" /v version /t REG_SZ /d "!VER!"     /f >nul
reg add "HKCU\Software\Google\Chrome\Extensions\!ID!"         /v path    /t REG_SZ /d "!CRX_FILE!" /f >nul
reg add "HKCU\Software\Google\Chrome\Extensions\!ID!"         /v version /t REG_SZ /d "!VER!"     /f >nul
set /a OK_COUNT+=1
echo      [OK] !PKG!
exit /b 0

:one_failed
echo      [ERROR] !PKG! - download or registry write failed
echo      [INFO]  Run this file again to repeat the list.
exit /b 0

:remove_all
for /l %%i in (1,1,%COUNT%) do call :remove_one %%i
echo.
echo Removed. Restart the browser and the extensions will be uninstalled.
echo.
pause
exit /b 0

:remove_one
set "PKG=!P%1_PKG!"
set "ID=!P%1_ID!"
set "CRX_FILE=%CRX_DIR%\!PKG!.crx"
reg delete "HKCU\Software\Yandex\YandexBrowser\Extensions\!ID!" /f >nul 2>&1
reg delete "HKCU\Software\Google\Chrome\Extensions\!ID!" /f >nul 2>&1
if exist "!CRX_FILE!" del /f /q "!CRX_FILE!" >nul
echo      removed: !PKG!
exit /b 0