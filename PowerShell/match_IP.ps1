# Ask the user for the log file path
$logFilePath = Read-Host -Prompt "Enter the path to the log file"

# Read the log file
$logContent = Get-Content -Path $logFilePath

# Regex pattern to match IPv4/6 addresses
$ipPattern = "\b(?:\d{1,3}\.){3}\d{1,3}\b|\b(?:[A-F0-9]{1,4}:){7}[A-F0-9]{1,4}\b"

# Find all IP addresses in the log file
$ipAddresses = $logContent | Select-String -Pattern $ipPattern -AllMatches | ForEach-Object {
    $_.Matches.Value
}

# Check if there are any matches
if ($ipAddresses.Count -eq 0) {
    Write-Host "No IP addresses found in the log file."
} else {
    # Output the matches
    $ipAddresses
}
