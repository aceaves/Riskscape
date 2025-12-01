# merge_summaries.ps1
# Merges all tab-delimited summary.csv files into one clean comma-separated CSV for Excel

$base = 'C:\2_Workspaces\Riskscape\Projects\Testing\output\total-exposed'
$out  = Join-Path $base 'all_summaries_total_exposed.csv'

# Remove any existing file
Remove-Item $out -ErrorAction Ignore

# Find folders that contain summary.csv
$dirs = Get-ChildItem $base -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'summary.csv') }
if ($dirs.Count -eq 0) { Write-Host "No summary.csv files found."; exit }

# Import first file to get column names
$first = Import-Csv (Join-Path $dirs[0].FullName 'summary.csv') -Delimiter "`t"
$cols  = @('FolderName') + ($first | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name)

# Merge and add FolderName column
$data = foreach ($d in $dirs) {
    $fn = $d.Name
    Import-Csv (Join-Path $d.FullName 'summary.csv') -Delimiter "`t" | ForEach-Object {
        $_ | Add-Member -NotePropertyName FolderName -NotePropertyValue $fn -Force
        $_
    }
}

# Reorder columns so FolderName is first
$ordered = $data | Select-Object $cols

# Write comma-separated output (Excel auto-splits)
$ordered | Export-Csv $out -NoTypeInformation -Delimiter ',' -Encoding UTF8

Write-Host "✅ Done! Combined file saved to $out"
