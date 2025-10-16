$logFile = "C:\ScriptLog.txt"

# Function to log messages (appends to file)
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $fullMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $fullMessage
    Write-Host $fullMessage  # Optional: Still show on console too
}

#>NetFramework3.5
try {
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart  
    Write-Log "Successfully enabled NetFramework3.5."
} catch {
    Write-Log "ERROR: Failed to enable NetFramework3.5."
}
#Microsoft print to PDF
try {
    Enable-WindowsOptionalFeature -Online -FeatureName Printing-PrintToPDFServices-Features -All -NoRestart
    Write-Log "Successfully enabled Microsoft print to PDF service."
} catch {
    Write-Log "ERROR: Failed to enable Microsoft print to PDF service."
}
#Telnet Client
try {
    Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -All -NoRestart
    Write-Log "Successfully enabledTelnet Client."
} catch {
    Write-Log "ERROR: Failed to enable Telnet Client."
}
#TFTP
try {
    Enable-WindowsOptionalFeature -Online -FeatureName TFTP -All -NoRestart

    Write-Log "Successfully enabled TFTP."
} catch {
    Write-Log "ERROR: Failed to enable TFTP."
}
