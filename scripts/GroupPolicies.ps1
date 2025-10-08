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

#Install Remote Server Administration Tools (RSAT)
try {
    choco install --cacheLocation="$ChocoCachePath" -y rsat
    Write-Log "Successfully installed Remote Server Administration Tools (RSAT)."
} catch {
    Write-Log "ERROR: Failed to install Remote Server Administration Tools (RSAT)."
}


