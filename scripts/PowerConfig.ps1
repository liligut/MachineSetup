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
    c$p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = 'High Performance'"  
    powercfg.exe -SETACTIVE ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","")
    powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    Write-Log "Successfully set High Performance power plan as the active power plan for the system."
} catch {
    Write-Log "ERROR: Failed to set High Performance power plan as the active power plan for the system."
}
