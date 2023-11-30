# Ask the user for the log file path
$logFilePath = Read-Host -Prompt "Enter the path to the log file"

# Read the log file
$logContent = Get-Content -Path $logFilePath

# Define a regular expression pattern to match IP addresses
$ipPattern = "\b(?:\d{1,3}\.){3}\d{1,3}\b"

# Find all IP addresses in the log file
$ipAddresses = $logContent | Select-String -Pattern $ipPattern -AllMatches | ForEach-Object {
    $_.Matches.Value
}

# Check if there are any matches
if ($ipAddresses.Count -eq 0) {
    Write-Host "No IP addresses found in the log file."
} else {
    # Output the matched IP addresses
    $ipAddresses
}
