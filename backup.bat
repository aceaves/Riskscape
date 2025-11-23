@echo off
setlocal

:: Get the folder where the .bat is stored
set "scriptdir=%~dp0"

:: Format date as YYYY-MM-DD (works in most locales)
for /f "tokens=1-3 delims=/- " %%a in ('date /t') do (
    set yyyy=%%c
    set mm=%%a
    set dd=%%b
)

:: Format time as HH-MM-SS
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set hh=%%a
    set min=%%b
    set sec=%%c
)

:: Build log filename with date and time
set "logfile=%scriptdir%backup_%yyyy%-%mm%-%dd%_%hh%-%min%-%sec%.log"

:: Add a timestamp header to log
echo Backup started at %date% %time% >> "%logfile%"

:: Run robocopy with dated log file
robocopy "D:\Riskscape" "I:\Land\LAND_INFORMATION\NaturalHazards\2_Workspaces\Riskscape" /MIR /R:2 /W:5 /LOG+:"%logfile%"

:: Add timestamp footer to log
echo Backup finished at %date% %time% >> "%logfile%"

endlocal
