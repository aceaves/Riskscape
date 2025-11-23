@echo off
setlocal enabledelayedexpansion

rem === Paths ===
set "RISKS_CAPE=C:\Program Files\riskscape\bin\riskscape.bat"
set "PROJECT_DIR=C:\2_Workspaces\Riskscape\Projects\Testing"
set "PROJECT_INI=%PROJECT_DIR%\project.ini"
set "ASSET_FILE=%PROJECT_DIR%\BuildingOutlinesProcessed_HB.shp"
set "OUTPUT_DIR=%PROJECT_DIR%\output\total-exposed"
set "MODEL=total-exposed"

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

rem === Loop through all .tif files ===
cd /d "%PROJECT_DIR%"
for %%F in (*.tif) do (
    echo ============================================
    echo Processing %%~nF%%~xF
    echo ============================================

    rem --- Update project.ini hazard references ---
    powershell -NoProfile -ExecutionPolicy Bypass ^
      -Command "$file = '%PROJECT_INI%';" ^
      "$content = Get-Content $file;" ^
      "$content = $content -replace 'input-hazards\.layer\s*=.*', 'input-hazards.layer = %PROJECT_DIR%\\%%~nF%%~xF';" ^
      "$content = $content -replace 'location\s*=.*Zone73\.tif', 'location = %PROJECT_DIR%\\%%~nF%%~xF';" ^
      "Set-Content -Path $file -Value $content;"

    rem --- Run RiskScape model ---
    "%RISKS_CAPE%" model run %MODEL% ^
        -p asset="%ASSET_FILE%" ^
        -o "%OUTPUT_DIR%\%%~nF"

    echo Done: %%~nF%%~xF
    echo Output written to: %OUTPUT_DIR%\%%~nF
    echo.
)

echo ============================================
echo All TIFFs processed.
echo ============================================
pause
