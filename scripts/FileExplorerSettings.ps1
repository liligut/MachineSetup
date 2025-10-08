$logFile = "C:\ScriptLog.txt"

# Function to log messages (appends to file)
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $fullMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $fullMessage
    Write-Host $fullMessage  # Optional: Still show on console too
}
  
#--- Configuring Windows properties ---
#--- Windows Features ---
# Show hidden files, Show protected OS files, Show file extensions
try {
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
    Write-Log "Successfully set windows explorer options to show hidden files, protected OS files, and file extensions."
} catch {
    Write-Log "ERROR: Failed to set windows explorer options to show hidden files, protected OS files, and file extensions."
}

#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
try {
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
    Write-Log "Successfully set windows explorer options to expand explorer to the actual folder you're in."
} catch {
    Write-Log "ERROR: Failed to set windows explorer options to expand explorer to the actual folder you're in."
}
#adds things back in your left pane like recycle bin
try {
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
    Write-Log "Successfully set windows explorer options to add things back in your left pane like recycle bin."
} catch {
    Write-Log "ERROR: Failed to set windows explorer options to add things back in your left pane like recycle bin."
}
#opens PC to This PC, not quick access
try {
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
    Write-Log "Successfully set windows explorer options to open PC to This PC, not quick access."
} catch {
    Write-Log "ERROR: Failed to set windows explorer options to set windows explorer options to open PC to This PC, not quick access."
}
#taskbar where window is open for multi-monitor
try {
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2
    Write-Log "Successfully set taskbar mode where window is open for multi-monitor."
} catch {
    Write-Log "ERROR: Failed to set taskbar mode where window is open for multi-monitor."
}
#disable windows defender
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name DisableRealtimeMonitoring -Value 1
#Set-ExecutionPolicy Unrestricted -scope LocalMachine
