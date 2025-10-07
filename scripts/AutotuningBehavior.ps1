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
    netsh int tcp set global autotuninglevel=disabled
    Write-Log "Successfully set autotuninglevel=disabled."
} catch {
    Write-Log "ERROR: Failed to set autotuninglevel=disabled."
}
