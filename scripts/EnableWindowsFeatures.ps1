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
Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"  
#Microsoft print to PDF
Enable-WindowsOptionalFeature -FeatureName "Printing-PrintToPDFServices-Features" -All -Online
#Telnet Client
Enable-WindowsOptionalFeature -Online -FeatureName "TelnetClient"
