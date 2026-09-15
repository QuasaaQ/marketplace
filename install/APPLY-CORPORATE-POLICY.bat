@echo off
setlocal enabledelayedexpansion
title APPLY-CORPORATE-POLICY - force install on managed PCs
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

set "QMPOL=%TEMP%\q-marketplace-extension-settings.json"
> "%QMPOL%" echo {"fdopdiehcmjhmgmeojageodobmmphngh":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/a-motivac-update.xml","override_update_url":true},"ckmfnfafacifdnkhijaidbbknlneogdj":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/a-motivac-grey-update.xml","override_update_url":true},"eglhcjgniigdanednhkaiakkjcpodkfg":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/a-oplat-update.xml","override_update_url":true},"menapjdenagdpanhbnbpgmhodpbkpmao":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/a-oplat-grey-update.xml","override_update_url":true},"pppnogmdbdgepnaeoodklllnianapeeb":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/ozon-wb-helper-update.xml","override_update_url":true},"cdoacknmgmgemgkhjemnlcmebofaldnb":{"installation_mode":"force_installed","update_url":"https://quasaaq.github.io/marketplace/downloads/yen-to-rub-update.xml","override_update_url":true}}
echo [1/3] Writing ExtensionSettings (force_installed, managed PC)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "foreach($r in @('HKCU:\SOFTWARE\Policies\YandexBrowser','HKCU:\SOFTWARE\Policies\Google\Chrome','HKCU:\SOFTWARE\Policies\Chromium','HKLM:\SOFTWARE\Policies\YandexBrowser','HKLM:\SOFTWARE\Policies\Google\Chrome','HKLM:\SOFTWARE\Policies\Chromium','HKLM:\SOFTWARE\WOW6432Node\Policies\YandexBrowser','HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome','HKLM:\SOFTWARE\WOW6432Node\Policies\Chromium')){ if(-not(Test-Path -LiteralPath $r)){ New-Item -Path $r -Force | Out-Null }; New-ItemProperty -Path $r -Name 'ExtensionSettings' -Value (Get-Content -Raw -LiteralPath $env:QMPOL) -PropertyType String -Force | Out-Null; Write-Host ('  policy: ' + $r) }"
if errorlevel 1 goto fail

echo [2/3] Writing install sources and allowlist...
for %%R in ("HKEY_CURRENT_USER\SOFTWARE\Policies\YandexBrowser" "HKEY_CURRENT_USER\SOFTWARE\Policies\Google\Chrome" "HKEY_CURRENT_USER\SOFTWARE\Policies\Chromium" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Chromium" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Chromium") do (
  reg delete "%%~R" /v ExtensionInstallForcelist /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallForcelist" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallSources" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallAllowlist" /f >nul 2>&1
  reg add "%%~R\ExtensionInstallSources" /v 1 /t REG_SZ /d "https://quasaaq.github.io/marketplace/*" /f >nul
  reg add "%%~R\ExtensionInstallSources" /v 2 /t REG_SZ /d "https://quasaaq.github.io/*" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 1 /t REG_SZ /d "fdopdiehcmjhmgmeojageodobmmphngh" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 2 /t REG_SZ /d "ckmfnfafacifdnkhijaidbbknlneogdj" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 3 /t REG_SZ /d "eglhcjgniigdanednhkaiakkjcpodkfg" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 4 /t REG_SZ /d "menapjdenagdpanhbnbpgmhodpbkpmao" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 5 /t REG_SZ /d "pppnogmdbdgepnaeoodklllnianapeeb" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 6 /t REG_SZ /d "cdoacknmgmgemgkhjemnlcmebofaldnb" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 7 /t REG_SZ /d "fkgkibajhfbepljeaefdnfnegdcjomkh" /f >nul
)

echo [3/3] Removing the legacy external crx registration...
for %%I in (fdopdiehcmjhmgmeojageodobmmphngh ckmfnfafacifdnkhijaidbbknlneogdj eglhcjgniigdanednhkaiakkjcpodkfg menapjdenagdpanhbnbpgmhodpbkpmao pppnogmdbdgepnaeoodklllnianapeeb cdoacknmgmgemgkhjemnlcmebofaldnb fkgkibajhfbepljeaefdnfnegdcjomkh) do (
  reg delete "HKCU\Software\Yandex\YandexBrowser\Extensions\%%I" /f >nul 2>&1
  reg delete "HKCU\Software\Google\Chrome\Extensions\%%I" /f >nul 2>&1
  reg delete "HKCU\Software\Chromium\Extensions\%%I" /f >nul 2>&1
)
del /f /q "%LOCALAPPDATA%\Q.Marketplace\*.crx" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Q.Marketplace\crx\*.crx" >nul 2>&1

echo ============================================================
echo  Policies applied. Manage them on browser://policy
echo ============================================================
echo.
echo  1. Close ALL browser windows completely (check the tray).
echo  2. Start the browser again.
echo  3. Run install-*.bat AS ADMINISTRATOR and confirm once.
echo.
pause
exit /b 0

:fail
echo [ERROR] Could not write the policy. Run as administrator.
pause
exit /b 1
