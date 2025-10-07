
# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$logFile = "C:\ScriptLog.txt"

# Function to log messages (appends to file)
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $fullMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $fullMessage
    Write-Host $fullMessage  # Optional: Still show on console too
}

$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

#choco install --cacheLocation="$ChocoCachePath" pswindowsupdate -y

Import-Module PSWindowsUpdate
Write-Output "Scanning for updates..."
$updates = Get-WindowsUpdate -AcceptEula

if ($updates.Count -eq 0) { Write-Output "No updates."; exit }

Write-Output "Downloading and installing $($updates.Count) updates..."
Install-WindowsUpdate -AcceptEula -AutoReboot:$true  # Set to $true for auto-reboot

# Optional: Reboot check
if (Get-WURebootStatus) { Restart-Computer -Force }
