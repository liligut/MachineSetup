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
    Install-Module -Name CredentialManager -Force
    New-StoredCredential -Target "90.0.0.20" -UserName "Administrator" -Password "Administrator" -Persist Enterprise -Type DomainPassword
    New-StoredCredential -Target "10.0.0.20" -UserName "Administrator" -Password "Administrator" -Persist Enterprise -Type DomainPassword
    Write-Log "Successfully added windows credentials."
} catch {
    Write-Log "ERROR: Failed to add windows creadentials."
}

