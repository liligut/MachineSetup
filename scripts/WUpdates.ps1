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

#$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
#New-Item -Path $ChocoCachePath -ItemType Directory -Force
#choco install --cacheLocation="$ChocoCachePath" pswindowsupdate -y

try {
    Install-Module -Name PSWindowsUpdate -Force
    Import-Module PSWindowsUpdate
    Write-Log "Successfully imported module PSWindowsUpdate."
    $updates = Get-WindowsUpdate
    if ($updates.Count -eq 0) { Write-Log  "There are no updates available."}
    else {
      Write-Log "Downloading and installing $($updates.Count) updates..."
      try {
        Install-WindowsUpdate -AcceptAll -AutoReboot:$true  # Set to $true for auto-reboot
        # Reboot check
        #if (Get-WURebootStatus) { Restart-Computer -Force }
      } catch { 
        Write-Log "ERROR: Failed to download and install windows update."
      }
    }
} catch {
    Write-Log "ERROR: Failed to install windows updates."
}





