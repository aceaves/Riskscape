@echo off
setlocal

rem === Paths ===
set "RISKS_CAPE=C:\Program Files\riskscape\bin\riskscape.bat"
set "PROJECT_DIR=D:\Riskscape\Projects\Testing"
set "ASSET_FILE=%PROJECT_DIR%\BuildingOutlinesProcessed_HB.shp"
set "OUTPUT_DIR=%PROJECT_DIR%\output\total-exposed"
set "MODEL=total-exposed"

rem === Loop through each .tif ===
cd /d "%PROJECT_DIR%"
for %%F in (*.tif) do (
    echo ============================================
    echo Processing %%~nF%%~xF
    echo ============================================

    "%RISKS_CAPE%" model run %MODEL% ^
        -p asset="%ASSET_FILE%" ^
        -p hazard="%%~fF" ^
        -o "%OUTPUT_DIR%\%%~nF"

    echo Done: %%~nF%%~xF
    echo Output written to: %OUTPUT_DIR%\%%~nF
    echo.
)

echo ============================================
echo All TIFFs processed.
echo ============================================
pause





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
