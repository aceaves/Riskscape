@echo off
setlocal enabledelayedexpansion

REM === Paths and settings ===
set "RISKS_CAPE=C:\Program Files\riskscape\bin\riskscape.bat"
set "PROJECT_DIR=D:\Riskscape\Projects\Testing"
set "ASSET_FILE=%PROJECT_DIR%\BuildingOutlinesProcessed_HB.shp"
set "DATA_DIR=%PROJECT_DIR%"
set "OUTPUT_DIR=%PROJECT_DIR%\output\total-exposed"
set "MODEL=total-exposed"

REM === Ensure output folder exists ===
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM === Loop through every .tif in the folder ===
for %%F in ("%DATA_DIR%\*.tif") do (
    echo ============================================
    echo Processing %%~nxf
    echo ============================================

    set "HAZARD_FILE=%DATA_DIR%\%%~nxf"

    "%RISKS_CAPE%" model run %MODEL% ^
        -p asset="%ASSET_FILE%" ^
        -p hazard="!HAZARD_FILE!" ^
        -o "%OUTPUT_DIR%"

    echo Done: %%~nxf
    echo.
)

echo ============================================
echo All TIFFs processed.
echo Output folder: %OUTPUT_DIR%
echo ============================================
pause
