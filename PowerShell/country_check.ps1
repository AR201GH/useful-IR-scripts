function Green
{
    process { Write-Host $_ -ForegroundColor Green }
}

function Red
{
    process { Write-Host $_ -ForegroundColor Red }
}
# Run netstat command and extract external IP addresses
$netstatOutput = netstat -n | Select-String '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' -AllMatches
$ipAddresses = $netstatOutput.Matches.Value | Where-Object { $_ -notlike "127.*.*.*" -and $_ -notlike "192.168.*.*" }

# Define the list of high-risk countries
$highRiskCountries = @(
    "China",
    "Brazil",
    "India",
    "Germany",
    "Vietnam",
    "Thailand",
    "Russia",
    "Indonesia",
    "Netherlands",
    "Iran",
    "Syria",
    "Ukraine",
    "Chile",
    "Sudan",
    "Poland",
    "South Korea",
    "North Korea",
    "Kazakhstan",
    "Serbia",
    "Uzbekistan",
    "Haiti",
    "Dominican Republic",
    "Bahamas",
    "Barbados",
    "Bermuda"
)

# Flag to track if any high-risk country matches are found
$foundMatches = $false

# Iterate through each external IP address
foreach ($ip in $ipAddresses) {
    # Perform API call to ipgeolocation.io
    $apiKey = "YOUR_API_KEY_HERE"
    $apiUrl = "https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&ip=$ip&fields=country_name"
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get

    # Extract country name from the response
    $countryName = $response.country_name

    # Check if the country is in the high-risk countries list
    if ($highRiskCountries -contains $countryName) {
        # Output the country name and IP address
        Write-Output "High risk connection found! Country: $countryName, IP: $ip" | Red
        $foundMatches = $true
    }
}

# Check if any high-risk country matches were found
if (-not $foundMatches) {
    Write-Output "No active connections detected from any high-risk countries!" | Green
}

