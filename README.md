# useful-IR-scripts
#### These scripts can be useful as part of an incident response investigation. 
Powershell scripts can be used in CrowdStrike RTR or ran locally.


## PowerShell Scripts

[Get pcap](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/get_pcap.ps1)
\- This script will generate a 30 second network capture and convert it to a .pcap file. It contains color-coded messages to indicate message type.

[Search file](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/search_file.ps1)
\- This script will search the current drive for filenames which contain the inputted keyword and will output the paths of any matches.

[Match IP](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/match_IP.ps1)
\- This script will match and IPs found in a provided log file and output the matches.

[Translate SID to username](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/translate-sid-to-username.ps1)
\- This script will convert a inputted SID to a username. This will need the [active directory module](https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps) installed. Active directiry module can be installed by ```import-module ActiveDirectory``` ran in an elevlated prompt.
