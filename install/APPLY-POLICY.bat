@echo off
setlocal enabledelayedexpansion
title APPLY-POLICY - enable one-click extension install
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "EXTID=cdoacknmgmgemgkhjemnlcmebofaldnb"
set "HOST1=https://quasaaq.github.io/marketplace/*"
set "HOST2=https://quasaaq.github.io/*"

echo ============================================================
echo  APPLY POLICY - allow one-click install from the site
echo ============================================================
echo.

for %%V in ("YandexBrowser" "Google\Chrome" "Chromium") do (
  for %%R in ("HKLM\SOFTWARE\Policies" "HKLM\SOFTWARE\WOW6432Node\Policies" "HKCU\SOFTWARE\Policies") do (
    reg delete "%%~R\%%~V" /v ExtensionInstallSources /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallSources" /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallAllowlist" /f >nul 2>&1
    reg delete "%%~R\%%~V" /v ExtensionInstallForcelist /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallForcelist" /f >nul 2>&1

    reg add "%%~R\%%~V\ExtensionInstallSources" /v 1 /t REG_SZ /d "%HOST1%" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallSources" /v 2 /t REG_SZ /d "%HOST2%" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 1 /t REG_SZ /d "%EXTID%" /f >nul
  )
)

echo Written to HKCU, HKLM and WOW6432Node for:
echo    YandexBrowser, Google\Chrome, Chromium
echo.
echo --- verify ---
reg query "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallSources" 2>nul
reg query "HKLM\SOFTWARE\Policies\Google\Chrome\ExtensionInstallAllowlist" 2>nul
echo.
echo ============================================================
echo  NEXT:
echo   1. Close ALL browser windows completely (check the tray).
echo   2. Start the browser again.
echo   3. Open https://quasaaq.github.io/marketplace/install/
echo   4. Press "Install in one click".
echo.
echo  Chrome: works. Yandex Browser: blocks third-party extensions
echo  on non-corporate PCs - use a packed (unpacked) install there.
echo ============================================================
echo.
pause
