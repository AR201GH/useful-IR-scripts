# useful-IR-scripts
#### These scripts can be useful as part of an incident response investigation. 
Powershell scripts can be used in CrowdStrike RTR or ran locally.

![image](https://github.com/AR201GH/useful-IR-scripts/assets/135081007/a395be80-53ff-42a2-8dfe-a8739a7f3145)
## PowerShell Scripts



[Get info](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell%2Fgather_info.ps1)
\- This script will gather and output various system information and match some against an external database. This script gathers the following:

* Local system information
* Environmental Variables
* Local users and groups
* Members of the build-in Administrators group
* List of installed products
* List of running services
* List of running processes
* List of Established and Listening network connections, including the port and responsible process
* Local DNS Cache
* Browser Extensions - Lists extension IDs. External lookup to match any malicious extension IDs to: https://github.com/mallorybowes/chrome-mal-ids/blob/master/current-list.csv (Only supports Chrome right now)
* Any recent files found in: AppData\Roaming\Microsoft\Windows\Recent

The results are out to a formatted HTML file named "output.html" and is placed in the current directory. Script will also output HTML file location when completed

Example output (Extensions Section):
![image](https://github.com/AR201GH/useful-IR-scripts/assets/135081007/bf926e72-13f6-47e4-a0e2-dafc28e0bb5f)


[Get pcap](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/get_pcap.ps1)
\- This script will generate a 30 second network capture and convert it to a .pcap file. It contains color-coded messages to indicate message type.

[Search file](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/search_file.ps1)
\- This script will search the current drive for filenames which contain the inputted keyword and will output the paths of any matches.

[Match IP](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/match_IP.ps1)
\- This script will match any IPV4/6 IPs found in a provided log file and output the matches.

[Translate SID to username](https://github.com/AR201GH/useful-IR-scripts/blob/main/PowerShell/translate-sid-to-username.ps1)
\- This script will convert a inputted SID to a username. This will need the [active directory module](https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps) installed. Active directory module can be installed by ```import-module ActiveDirectory``` ran in an elevated prompt.



![image](https://github.com/AR201GH/useful-IR-scripts/assets/135081007/5ec66511-04d5-46dd-abdb-864e820b8133)
## Python Scripts
[Decode base 64](https://github.com/AR201GH/useful-IR-scripts/blob/main/Python/decode-base64.py)
\- This script will decode entered base64 and output the decoded results.

[Decode Character encoding](https://github.com/AR201GH/useful-IR-scripts/blob/main/Python/decode-char-code.py)
***Script needs configuring*** - input decimal representations of character encoding (no x) Example - ```[dec1, dec2, dec3, etc]```
 
 This script will decode character code encoding and output the decoded results. 
