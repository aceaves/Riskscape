# merge_summaries.ps1

$base = 'C:\2_Workspaces\Riskscape\Projects\Testing\output\total-exposed'
$out  = Join-Path $base 'all_summaries_total_exposed.csv'

Remove-Item $out -ErrorAction Ignore

# Collect folders that contain summary.csv
$dirs = Get-ChildItem $base -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName 'summary.csv')
}

if (-not $dirs -or $dirs.Count -eq 0) {
    Write-Host "❌ No summary.csv files found under:" $base
    exit
}

Write-Host "Found $($dirs.Count) folders with summary.csv"

#########################################
# Function: load CSV with auto-delimiter
#########################################
function Load-Summary {
    param ($path)

    $raw = Get-Content $path -TotalCount 1
    if ($raw -match ",")   { $d = "," }
    elseif ($raw -match "`t") { $d = "`t" }
    else { $d = "," }

    return Import-Csv $path -Delimiter $d
}

# Load first file to build header map
$firstFile = Join-Path $dirs[0].FullName 'summary.csv'
$first     = Load-Summary $firstFile

$cols = @('FolderName') + ($first | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name)

# Merge all folders
$data = foreach ($d in $dirs) {
    $file = Join-Path $d.FullName 'summary.csv'
    Load-Summary $file | ForEach-Object {
        $_ | Add-Member FolderName $d.Name -Force
        $_
    }
}

# Output
$data | Select-Object $cols | Export-Csv $out -NoTypeInformation -Encoding UTF8

Write-Host "✅ DONE → $out"

