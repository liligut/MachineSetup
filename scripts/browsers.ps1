$logFile = "C:\ScriptLog.txt"

# Function to log messages (appends to file)
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $fullMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $fullMessage
    Write-Host $fullMessage  # Optional: Still show on console too
}

try {
    choco install -y googlechrome
    Write-Log "Successfully installed googlechrome."
} catch {
    Write-Log "ERROR: Failed to install googlechrome."
}

try {
    choco install -y filezilla
    Write-Log "Successfully installed filezilla."
} catch {
    Write-Log "ERROR: Failed to install filezilla."
}
