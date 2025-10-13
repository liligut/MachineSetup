# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
# Log file path
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

#--- CPU-Z
try {
    choco install --cacheLocation="$ChocoCachePath" -y cpu-z
    Write-Log "Successfully installed CPU-Z."
} catch {
    Write-Log "ERROR: Failed to install CPU-Z."
}
#--- CoreTemp
try {
    choco install --cacheLocation="$ChocoCachePath" -y coretemp
    Write-Log "Successfully installed CoreTemp."
} catch {
    Write-Log "ERROR: Failed to install CoreTemp."
}
#--- Microsoft .NET Framework
try {
    choco install --cacheLocation="$ChocoCachePath" dotnetfx
    Write-Log "Successfully installed Microsoft .NET Framework."
} catch {
    Write-Log "ERROR: Failed to install Microsoft .NET Framework."
}
#--- Visual Studio Code
try {
    choco install --cacheLocation="$ChocoCachePath" -y vscode
    Write-Log "Successfully installed Visual Studio Code."
} catch {
    Write-Log "ERROR: Failed to install Visual Studio Code."
}
#--- Sysinternals
try {
    #choco install --cacheLocation="$ChocoCachePath" -y sysinternals
    #Write-Log "Successfully installed Sysinternals."
} catch {
    #Write-Log "ERROR: Failed to install Sysinternals."
}
#--- BeyondCompare
try {
    choco install --cacheLocation="$ChocoCachePath" beyondcompare
    Write-Log "Successfully installed BeyondCompare."
} catch {
    Write-Log "ERROR: Failed to install BeyondCompare."
}
#--- Putty
try {
    choco install --cacheLocation="$ChocoCachePath" putty
    Write-Log "Successfully installed Putty."
} catch {
    Write-Log "ERROR: Failed to install Putty."
}
#--- SQL Server Express 
try {
    choco install sql-server-express -o -ia "'/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER /UPDATEENABLED=FALSE'" -y
    #choco install mssqlexpress2014sp1wt -params "'/INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER'" -y
    Write-Log "Successfully installed SQL Server Express."
} catch {
    Write-Log "ERROR: Failed to install SQL Server Express."
}
#--- Adobe Reader 
try {
    choco install --cacheLocation="$ChocoCachePath" adobereader
    Write-Log "Successfully installed Adobe Reader."
} catch {
    Write-Log "ERROR: Failed to install Adobe Reader."
}
#--- Microsoft Windows Terminal
try {
    hoco install --cacheLocation="$ChocoCachePath" microsoft-windows-terminal
    Write-Log "Successfully installed Microsoft Windows Terminal."
} catch {
    Write-Log "ERROR: Failed to install Microsoft Windows Terminal."
}
#--- SQL Server Management Studio
try {
    choco install --cacheLocation="$ChocoCachePath" sql-server-management-studio -y
    Write-Log "Successfully installed SQL Server Management Studio."
} catch {
    Write-Log "ERROR: Failed to install SQL Server Management Studio."
}
#--- Git
try {
    choco install --cacheLocation="$ChocoCachePath" --force git -y
    Write-Log "Successfully installed git."
} catch {
    Write-Log "ERROR: Failed to install git."
}
#--- Tortoise git
try {
    choco install --cacheLocation="$ChocoCachePath" tortoisegit -y
    Write-Log "Successfully installed Tortoise git."
} catch {
    Write-Log "ERROR: Failed to install Tortoise git."
}
#Refresh Environment Variables
Get-ChildItem Env: | ForEach-Object { $_.Value = [Environment]::GetEnvironmentVariable($_.Name) }
