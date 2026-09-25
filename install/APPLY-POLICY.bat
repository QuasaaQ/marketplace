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

echo [1/4] Clearing the neutralized ExtensionSettings value...
powershell -NoProfile -ExecutionPolicy Bypass -Command "foreach($r in @('HKCU:\SOFTWARE\Policies\YandexBrowser','HKCU:\SOFTWARE\Policies\Google\Chrome','HKCU:\SOFTWARE\Policies\Chromium','HKLM:\SOFTWARE\Policies\YandexBrowser','HKLM:\SOFTWARE\Policies\Google\Chrome','HKLM:\SOFTWARE\Policies\Chromium','HKLM:\SOFTWARE\WOW6432Node\Policies\YandexBrowser','HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome','HKLM:\SOFTWARE\WOW6432Node\Policies\Chromium')){ Remove-ItemProperty -Path $r -Name 'ExtensionSettings' -ErrorAction SilentlyContinue }"

echo [2/4] Removing the obsolete Manifest V2 policy value...
for %%R in ("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Chromium" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Chromium") do (
  reg delete "%%~R" /v ExtensionManifestV2Availability /f >nul 2>&1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c=0; foreach($r in @('HKLM:\SOFTWARE\Policies\YandexBrowser','HKLM:\SOFTWARE\Policies\Google\Chrome','HKLM:\SOFTWARE\Policies\Chromium','HKLM:\SOFTWARE\WOW6432Node\Policies\YandexBrowser','HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome','HKLM:\SOFTWARE\WOW6432Node\Policies\Chromium')){ $v=(Get-ItemProperty -LiteralPath $r -ErrorAction SilentlyContinue).PSObject.Properties['ExtensionInstallSources']; if($v){ $c++ } }; Write-Host ('  Install sources written in ' + $c + ' of 6 machine branches'); if($c -ne 6){ Write-Host '  [WARNING] Run this file AS ADMINISTRATOR - without elevation the Policies branch is read-only.' }"

echo [3/4] Writing install sources and allowlist...
for %%R in ("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Chromium" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Chromium") do (
  reg delete "%%~R" /v ExtensionInstallForcelist /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallForcelist" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallSources" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallAllowlist" /f >nul 2>&1
  reg add "%%~R\ExtensionInstallSources" /v 1 /t REG_SZ /d "https://quasaaq.github.io/marketplace/*" /f >nul
  reg add "%%~R\ExtensionInstallSources" /v 2 /t REG_SZ /d "https://quasaaq.github.io/*" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 1 /t REG_SZ /d "fdopdiehcmjhmgmeojageodobmmphngh" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 2 /t REG_SZ /d "ckmfnfafacifdnkhijaidbbknlneogdj" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 3 /t REG_SZ /d "menapjdenagdpanhbnbpgmhodpbkpmao" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 4 /t REG_SZ /d "eglhcjgniigdanednhkaiakkjcpodkfg" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 5 /t REG_SZ /d "pppnogmdbdgepnaeoodklllnianapeeb" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 6 /t REG_SZ /d "cdoacknmgmgemgkhjemnlcmebofaldnb" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 7 /t REG_SZ /d "aafcbgdepfbaicngmbeknofmllehbmmk" /f >nul
  reg add "%%~R\ExtensionInstallAllowlist" /v 8 /t REG_SZ /d "fkgkibajhfbepljeaefdnfnegdcjomkh" /f >nul
)
for %%R in ("HKEY_CURRENT_USER\SOFTWARE\Policies\YandexBrowser" "HKEY_CURRENT_USER\SOFTWARE\Policies\Google\Chrome" "HKEY_CURRENT_USER\SOFTWARE\Policies\Chromium") do (
  reg delete "%%~R" /v ExtensionManifestV2Availability /f >nul 2>&1
  reg delete "%%~R" /v ExtensionSettings /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallSources" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallAllowlist" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallForcelist" /f >nul 2>&1
)

echo [4/4] Removing the legacy external crx registration...
for %%I in (fdopdiehcmjhmgmeojageodobmmphngh ckmfnfafacifdnkhijaidbbknlneogdj menapjdenagdpanhbnbpgmhodpbkpmao eglhcjgniigdanednhkaiakkjcpodkfg pppnogmdbdgepnaeoodklllnianapeeb cdoacknmgmgemgkhjemnlcmebofaldnb aafcbgdepfbaicngmbeknofmllehbmmk fkgkibajhfbepljeaefdnfnegdcjomkh) do (
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
echo  The obsolete Manifest V2 policy value is removed from both scopes.
echo  Modern Chrome dropped Manifest V2 itself; Yandex Browser keeps it.
echo.
echo  install-policy.reg must be applied AS ADMINISTRATOR too: a merged
echo  .reg raises no UAC prompt and Windows silently denies writes to the
echo  Policies branch, so the policy would not appear at all.
echo.
pause
exit /b 0

:fail
echo [ERROR] Could not write the policy. Run as administrator.
pause
exit /b 1
