@echo off
setlocal enabledelayedexpansion

set "base_dir=D:\Riskscape\Projects\Testing\output\total-exposed"
set "output=%base_dir%\all_summaries.csv"

rem delete old combined file if it exists
if exist "%output%" del "%output%"

set "firstFile=true"

for /d %%D in ("%base_dir%\*") do (
    if exist "%%D\summary.csv" (
        echo Adding %%D\summary.csv
        if "!firstFile!"=="true" (
            rem include header
            type "%%D\summary.csv" >> "%output%"
            set "firstFile=false"
        ) else (
            rem skip first line (header) for all subsequent files
            more +1 "%%D\summary.csv" >> "%output%"
        )
    )
)

echo Done!
echo Combined file: %output%
pause
