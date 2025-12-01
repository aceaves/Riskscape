@echo off
setlocal

rem === Paths ===
set "RISKS_CAPE=C:\Program Files\riskscape\bin\riskscape.bat"
set "PROJECT_DIR=C:\2_Workspaces\Riskscape\Projects\Testing"
set "PROJECT_INI=%PROJECT_DIR%\project.ini"
set "ASSET_FILE=%PROJECT_DIR%\BuildingOutlinesProcessed_HB.shp"
set "OUTPUT_ROOT=%PROJECT_DIR%\output\building-damage"

rem Create output root if missing
if not exist "%OUTPUT_ROOT%" mkdir "%OUTPUT_ROOT%"

cd /d "%PROJECT_DIR%"

rem === Loop through all .tif files ===
for %%F in (*.tif) do (
    echo ============================================
    echo Processing hazard: %%~nF%%~xF
    echo ============================================

    rem --- Update project.ini hazard reference on the fly ---
    powershell -NoProfile -ExecutionPolicy Bypass ^
      -Command "$file = '%PROJECT_INI%'; $c = Get-Content $file -Raw; " ^
      "$c = $c -replace 'input-hazards\.layer\s*=.*', 'input-hazards.layer = %PROJECT_DIR%\\%%~nF%%~xF'; " ^
      "$c = $c -replace 'location\s*=.*Zone73\.tif', 'location = %PROJECT_DIR%\\%%~nF%%~xF'; " ^
      "Set-Content -Path $file -Value $c;"

    rem --- Create a folder under building-damage named after the TIFF (no !OUT_DIR!) ---
    if not exist "%OUTPUT_ROOT%\%%~nF" mkdir "%OUTPUT_ROOT%\%%~nF"

    rem --- Run RiskScape building-damage model, output to that folder ---
    "%RISKS_CAPE%" model run "building-damage" ^
        -p asset="%ASSET_FILE%" ^
        -o "%OUTPUT_ROOT%\%%~nF"

    echo Done: %%~nF%%~xF
    echo Output written to: %OUTPUT_ROOT%\%%~nF
    echo.
)

echo ============================================
echo All hazard TIFFs processed.
echo Outputs in folders under:
echo   %OUTPUT_ROOT%
echo ============================================
pause
