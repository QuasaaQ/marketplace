@echo off
setlocal enabledelayedexpansion
title CLEAN-OLD-SCHEME - remove legacy external crx registration
chcp 65001 >nul
echo Removing the legacy external extension registration keys...
for %%I in (fdopdiehcmjhmgmeojageodobmmphngh ckmfnfafacifdnkhijaidbbknlneogdj eglhcjgniigdanednhkaiakkjcpodkfg menapjdenagdpanhbnbpgmhodpbkpmao pppnogmdbdgepnaeoodklllnianapeeb cdoacknmgmgemgkhjemnlcmebofaldnb) do (
  reg delete "HKCU\Software\Yandex\YandexBrowser\Extensions\%%I" /f >nul 2>&1
  reg delete "HKCU\Software\Google\Chrome\Extensions\%%I" /f >nul 2>&1
  reg delete "HKCU\Software\Chromium\Extensions\%%I" /f >nul 2>&1
  echo   removed: %%I
)
del /f /q "%LOCALAPPDATA%\Q.Marketplace\*.crx" >nul 2>&1
del /f /q "%LOCALAPPDATA%\Q.Marketplace\crx\*.crx" >nul 2>&1
echo.
echo Done. Restart the browser.
pause
