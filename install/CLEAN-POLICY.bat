@echo off
setlocal enabledelayedexpansion
title CLEAN-POLICY - remove installed policies
chcp 65001 >nul

net session >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator rights...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo ============================================================
echo  CLEAN POLICY - remove all policies set by this project
echo ============================================================
echo.

for %%V in ("YandexBrowser" "Google\Chrome" "Chromium") do (
  for %%R in ("HKLM\SOFTWARE\Policies" "HKLM\SOFTWARE\WOW6432Node\Policies" "HKCU\SOFTWARE\Policies") do (
    reg delete "%%~R\%%~V" /v ExtensionInstallSources /f >nul 2>&1
    reg delete "%%~R\%%~V" /v ExtensionInstallAllowlist /f >nul 2>&1
    reg delete "%%~R\%%~V" /v ExtensionInstallForcelist /f >nul 2>&1
    reg delete "%%~R\%%~V" /v ShowHomeButton /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallSources" /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallAllowlist" /f >nul 2>&1
    reg delete "%%~R\%%~V\ExtensionInstallForcelist" /f >nul 2>&1
  )
)

echo Removed. Restart the browser for the changes to take effect.
echo.
pause
