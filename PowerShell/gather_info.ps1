# FILEPATH: gather_info.ps1

function Write-Message {
    <#
    .SYNOPSIS
        Prints colored messages depending on type
    .PARAMETER TYPE
        Type of error message to be prepended to the message and sets the color
    .PARAMETER MESSAGE
        Message to be output
    #>
    [CmdletBinding()]
    param (
        [string]$Type,
        [string]$Message
    )

    if ($Type -eq "INFO") {
        Write-Host -ForegroundColor Green "INFO: $Message"
    } elseif ($Type -eq "WARNING") {
        Write-Host -ForegroundColor Yellow "WARNING: $Message"
    } elseif ($Type -eq "ERROR") {
        Write-Host -ForegroundColor Red "ERROR: $Message"
    } else {
        Write-Host $Message
    }
}
# Get system information
Write-Message -Type "INFO" -Message "Getting system information..."
$systemInfo = Get-WmiObject -Class Win32_ComputerSystem
Start-Sleep -Seconds 1

# Get local users
Write-Message -Type "INFO" -Message "Getting local users..."
$localUsers = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'"
Start-Sleep -Seconds 1

# Get local groups
Write-Message -Type "INFO" -Message "Getting local groups..."
$localGroups = Get-WmiObject -Class Win32_Group -Filter "LocalAccount='True'"
Start-Sleep -Seconds 1

# Get members of the administrator group
Write-Message -Type "INFO" -Message "Getting members of the administrator group..."
$adminGroup = Get-WmiObject -Class Win32_Group -Filter "Name='Administrators'"
$adminMembers = $adminGroup.GetRelated("Win32_UserAccount")
Start-Sleep -Seconds 1

# Get environmental variables
Write-Message -Type "INFO" -Message "Getting environmental variables..."
$envVariables = Get-ChildItem -Path "Env:" | Select-Object -Property Name, Value
Start-Sleep -Seconds 1

# Get installed products
Write-Message -Type "INFO" -Message "Getting installed products..."
$installedProducts = Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version, Vendor
Start-Sleep -Seconds 1

# Get running services
Write-Message -Type "INFO" -Message "Getting running services..."
$services = Get-Service | Where-Object { $_.Status -eq 'Running' }
Start-Sleep -Seconds 1

# Get running processes
Write-Message -Type "INFO" -Message "Getting running processes..."
$processes = Get-Process -IncludeUserName | Where-Object { $_.Responding }
Start-Sleep -Seconds 1

# Get current established network connections
Write-Message -Type "INFO" -Message "Getting current Established network connections..."
$connections = get-nettcpconnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | Where-Object { $_.State -eq 'Established' }
Start-Sleep -Seconds 1

# Get current Listening network connections
Write-Message -Type "INFO" -Message "Getting current Listening network connections..."
$connectionsL = get-nettcpconnection | select local*,remote*,state,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | Where-Object { $_.State -eq 'Listen' }
Start-Sleep -Seconds 1

# Get local DNS cache
Write-Message -Type "INFO" -Message "Getting local DNS cache..."
$dnsCache = Get-DnsClientCache
Start-Sleep -Seconds 1

# Get browser extensions
Write-Message -Type "INFO" -Message "Getting browser extensions..."
$browserExtensions = Get-ChildItem -Path "C:\Users\$($env:USERNAME)\AppData\Local\Google\Chrome\User Data\Default\Extensions"
Start-Sleep -Seconds 1

# Scrape the webpage to get extension names based on IDs
$extensionNames = @{}
$url = "https://github.com/mallorybowes/chrome-mal-ids/blob/master/current-list.csv"
$response = Invoke-WebRequest -Uri $url
$htmlr = $response.Content

# Extract extension names from the webpage
$extensionIds = $browserExtensions.Name
foreach ($extensionId in $extensionIds) {
    $extensionName = $htmlr | Select-String -Pattern $extensionId | ForEach-Object { $_.Matches.Value.Trim('"') }
    if ($extensionName) {
        $extensionNames[$extensionId] = $extensionName
    }
}

 # Get users recently viewed files
 Write-Message -Type "INFO" -Message "Getting users recently viewed files..."
 $recentFiles = Get-ChildItem -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Recent" -Filter '*.lnk'
 Write-Message -Type "INFO" -Message "Done!"
 # Convert the gathered information to HTML format
Write-Message -Type "INFO" -Message "Converting to HTML File..."
 
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Gathered Information</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #85d2ff;
        }
        h1 {
            width:1000px;
            margin: 0 auto;
            text-align: center;
        }
        #logo {
            display: inline-block;
            margin: 15px; /* margin: 20px was off */
            float: left;
            height: 60px;
            width: auto; /* correct proportions to specified height */
            border-radius: 100%; /* makes it a circle */
          }
    </style>
</head>
"@
$html += @"
    </table>
</html>
        
</head>
    <body>
    <a href="#"><img id="logo" src="https://lh3.googleusercontent.com/drive-viewer/AK7aPaALXKmRgst461F4KJIQ1MRwumkiGGsZyk3H0Q8o5Y2-vLuIFZqxYl52WRUNKzDZJZlLKwrTdDE-wobNgs3OqZg5K8VlHQ=s2560"></a>
    <h1>Get-info Script - Gather relevant info, quickly!</h1>
    <br />
    <br />
    <h2>System Information</h2>
    <table>
        <tr>
            <th>Property</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Name</td>
            <td>$($systemInfo.Name)</td>
        </tr>
        <tr>
            <td>Model</td>
            <td>$($systemInfo.Model)</td>
        </tr>
        <tr>
            <td>Manufacturer</td>
            <td>$($($systemInfo.Manufacturer))</td>
        </tr>
        <tr>
            <td>Owner</td>
            <td>$($systemInfo.PrimaryOwnerName)</td>
        </tr>
    </table>
    
    <h2>Local Users</h2>
    <table>
        <tr>
            <th>Username</th>
            <th>Full Name</th>
        </tr>
        $(foreach ($user in $localUsers) {
            "<tr>
                <td>$($user.Name)</td>
                <td>$($user.FullName)</td>
            </tr>"
        })
    </table>
    
    <h2>Local Groups</h2>
    <table>
        <tr>
            <th>Group Name</th>
            <th>Description</th>
        </tr>
        $(foreach ($group in $localGroups) {
            "<tr>
                <td>$($group.Name)</td>
                <td>$($group.Description)</td>
            </tr>"
        })
    </table>
    
    <h2>Members of Administrator Group</h2>
    <table>
        <tr>
            <th>Username</th>
        </tr>
        $(foreach ($member in $adminMembers) {
            "<tr>
                <td>$member</td>
            </tr>"
        })
    </table>
    
    <h2>Environmental Variables</h2>
    <table>
        <tr>
            <th>Name</th>
            <th>Value</th>
        </tr>
        $(foreach ($variable in $envVariables) {
            "<tr>
                <td>$($variable.Name)</td>
                <td>$($variable.Value)</td>
            </tr>"
        })
    </table>
    
    <h2>Installed Products</h2>
    <table>
        <tr>
            <th>Name</th>
            <th>Version</th>
            <th>Vendor</th>
        </tr>
        $(foreach ($product in $installedProducts) {
            "<tr>
                <td>$($product.Name)</td>
                <td>$($product.Version)</td>
                <td>$($product.Vendor)</td>
            </tr>"
        })
    </table>

    <h2>Running Services</h2>
    <table>
        <tr>
            <th>Name</th>
            <th>Display Name</th>
            <th>Status</th>
        </tr>
        $(foreach ($service in $services) {
            "<tr><td>$($service.Name)</td><td>$($service.DisplayName)</td><td>$($service.Status)</td></tr>"
        })
    </table>

    <h2>Running Processes</h2>
    <table>
        <tr>
            <th>PID</th>
            <th>Process Name</th>
            <th>User Name</th>
            <th>Responding</th>
        </tr>
        $(foreach ($process in $processes) {
            "<tr><td>$($process.Id)</td><td>$($process.Name)</td></td></td><td>$($process.UserName)</td><td>$($process.Responding)</td></tr>"
        })
    </table>

    <h2>Current Established Network Connections</h2>
    <table>
        <tr>
            <th>Local Address</th>
            <th>Local Port</th>
            <th>Remote Address</th>
            <th>Remote Port</th>
            <th>Process</th>
        </tr>
        $(foreach ($connection in $connections) {
            "<tr><td>$($connection.LocalAddress)</td><td>$($connection.LocalPort)</td><td>$($connection.RemoteAddress)</td><td>$($connection.RemotePort)</td><td>$($connection.Process)</td></tr>"
        })
    </table>

    <h2>Current Established Listening Connections</h2>
    <table>
        <tr>
            <th>Local Address</th>
            <th>Local Port</th>
            <th>Process</th>
        </tr>
        $(foreach ($connection in $connectionsL) {
            "<tr><td>$($connection.LocalAddress)</td><td>$($connection.LocalPort)</td><td>$($connection.Process)</td></tr>"
        })
    </table>

    <h2>Local DNS Cache</h2>
    <table>
        <tr>
            <th>Record Entry</th>
            <th>Record Name</th>
            <th>Record Type</th>
            <th>Data</th>
            <th>Time-to-Live (Minutes)</th>
        </tr>
        $(foreach ($record in $dnsCache) {
            $dnstypes = @{
                [uint16]1 = "A"
                [uint16]2 = "NS"
                [uint16]5 = "CNAME"
                [uint16]6 = "SOA"
                [uint16]12 = "PTR"
                [uint16]15 = "MX"
                [uint16]28 = "AAA"
                [uint16]33 = "SRV"
            }

            $recordType = $dnstypes[[uint16]$record.Type]
            $ttlMinutes = $record.TTL / 60
            "<tr><td>$($record.Entry)</td><td>$($record.Name)</td><td>$recordType</td><td>$($record.Data)</td><td>$($ttlMinutes.ToString("#.##"))</td></tr>"
        })
    </table>

        <h2>Browser Extensions</h2>
    <table>
        <tr>
            <th>Extension ID</th>
            <th>Malicious ID</th> <!-- New column -->
        </tr>
        $(foreach ($extension in $browserExtensions) {
            $extensionIds = $extension.Name
            $maliciousId = $extensionNames[$extensionIds]
        "<tr><td>$extensionIds</td><td>$maliciousId</td></tr>"
        })
    </table>

    <h2>Recently Viewed Files</h2>
    <table>
        <tr>
            <th>Name</th>
            <th>Last Accessed</th>
        </tr>
        $(if ($recentFiles.Count -eq 0) {
            "<tr><td colspan='2'>No results, or recent activity turned off</td></tr>"
        } else {
            $(foreach ($file in $recentFiles) {
                "<tr><td>$($file.Name)</td><td>$($file.LastAccessTime)</td></tr>"
            })
        })
    </table>
    </body>
</html>
"@

# Save the HTML output to a file
$htmlPath = 'get_info_output.html'
$html | Out-File -FilePath $htmlPath
Write-Message -Type "INFO" -Message "HTML file generated at: $((Get-Item -Path $htmlPath).FullName)"