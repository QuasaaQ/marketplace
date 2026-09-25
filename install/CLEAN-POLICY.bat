@echo off
setlocal enabledelayedexpansion
title CLEAN-POLICY - remove marketplace policies
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

for %%R in ("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\YandexBrowser" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Google\Chrome" "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Chromium" "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Chromium") do (
  reg delete "%%~R" /v ExtensionSettings /f >nul 2>&1
  reg delete "%%~R" /v ExtensionManifestV2Availability /f >nul 2>&1
  reg delete "%%~R" /v ShowHomeButton /f >nul 2>&1
  reg delete "%%~R" /v ExtensionInstallSources /f >nul 2>&1
  reg delete "%%~R" /v ExtensionInstallAllowlist /f >nul 2>&1
  reg delete "%%~R" /v ExtensionInstallForcelist /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallSources" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallAllowlist" /f >nul 2>&1
  reg delete "%%~R\ExtensionInstallForcelist" /f >nul 2>&1
)

echo Policies removed. Restart the browser.
pause
