@echo off
setlocal enabledelayedexpansion
title APPLY-POLICY - allow one-click extension install
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

for %%R in ("HKLM\SOFTWARE\Policies" "HKLM\SOFTWARE\WOW6432Node\Policies" "HKCU\SOFTWARE\Policies") do (
  for %%V in ("YandexBrowser" "Google\Chrome" "Chromium") do (
    reg delete "%%~R\%%~V" /v ExtensionInstallSources /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallSources" /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallAllowlist" /f >nul 2>&1
    reg delete "%%~R\%%~V" /v ExtensionInstallForcelist /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallForcelist" /f >nul 2>&1

    reg add "%%~R\%%~V\ExtensionInstallSources" /v 1 /t REG_SZ /d "https://quasaaq.github.io/marketplace/*" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallSources" /v 2 /t REG_SZ /d "https://quasaaq.github.io/*" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 1 /t REG_SZ /d "cdoacknmgmgemgkhjemnlcmebofaldnb" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 2 /t REG_SZ /d "fdopdiehcmjhmgmeojageodobmmphngh" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 3 /t REG_SZ /d "ckmfnfafacifdnkhijaidbbknlneogdj" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 4 /t REG_SZ /d "menapjdenagdpanhbnbpgmhodpbkpmao" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 5 /t REG_SZ /d "eglhcjgniigdanednhkaiakkjcpodkfg" /f >nul
    reg add "%%~R\%%~V\ExtensionInstallAllowlist" /v 6 /t REG_SZ /d "pppnogmdbdgepnaeoodklllnianapeeb" /f >nul
  )
)

echo ============================================================
echo  Policies applied.
echo  Extensions in allowlist: 6
echo ============================================================
echo.
echo  1. Close ALL browser windows completely (check the tray).
  2. Start the browser again.
  3. Open the marketplace site and press "Install in one click".
echo.
pause
