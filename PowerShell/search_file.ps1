param (
    [Parameter(Mandatory=$true)]
    [string]$SearchPattern
)

# Append a wildcard character (*) on each side to the search pattern to match any file extension
$SearchPattern = "*$SearchPattern"

# Search for files matching the search pattern in the entire current drive
$files = Get-ChildItem -Path $env:SystemDrive -Recurse -File -Filter $SearchPattern

# Display the results
if ($files.Count -gt 0) {
    Write-Host "Found $($files.Count) file(s) matching '$SearchPattern' in the entire current drive:"
    $files | ForEach-Object {
        Write-Host $_.FullName
    }
} else {
    Write-Host "No files found matching '$SearchPattern' in the entire current drive."
}
