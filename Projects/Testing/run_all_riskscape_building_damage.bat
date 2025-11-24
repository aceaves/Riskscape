@echo off
setlocal enabledelayedexpansion

REM === Paths ===
set "RISKS_CAPE=C:\Program Files\riskscape\bin\riskscape.bat"
set "PROJECT_DIR=C:\2_Workspaces\Riskscape\Projects\Testing"
set "EXPOSURE=C:/2_Workspaces/Riskscape/Projects/Testing/BuildingOutlinesProcessed_HB.shp"
set "MODEL=building-damage"
set "OUTPUT_ROOT=%PROJECT_DIR%\output\building-damage"

REM Create output folder if missing
if not exist "%OUTPUT_ROOT%" mkdir "%OUTPUT_ROOT%"

cd /d "%PROJECT_DIR%"

REM === Loop through all .tif files ===
for %%F in (*.tif) do (
    echo ============================================
    echo Processing hazard: %%~nF%%~xF
    echo ============================================

    REM Output folder for this run
    set "OUT_DIR=%OUTPUT_ROOT%\%%~nF"
    if not exist "!OUT_DIR!" mkdir "!OUT_DIR!"

    REM --- Run RiskScape model ---
    "%RISKS_CAPE%" model run %MODEL% ^
        -p exposure="%EXPOSURE%" ^
        -p hazard="%PROJECT_DIR%/%%~nF%%~xF" ^
        -o "!OUT_DIR!"

    echo Done: %%~nF%%~xF
    echo Output written to: !OUT_DIR!
    echo.
)

echo ============================================
echo All hazard TIFFs processed.
echo ============================================
pause
