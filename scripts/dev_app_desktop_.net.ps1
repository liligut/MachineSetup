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

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "devtools.ps1";


$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

#--- Tools ---
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022professional
#choco install -y visualstudio2019professional

#--- SDKs ---
try {
    choco install --cacheLocation="$ChocoCachePath" dotnetcore-sdk
    choco install --cacheLocation="$ChocoCachePath" dotnet3.5
    choco install --cacheLocation="$ChocoCachePath" dotnet
    choco install --cacheLocation="$ChocoCachePath" dotnet-5.0-sdk
    Write-Log "Successfully installed dot net."
} catch {
    Write-Log "ERROR: Failed to install dot net."
}

#--- Workloads ---
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-manageddesktop
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-manageddesktopbuildtools
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-nativedesktop
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2019-workload-netcoretools


#--- SQL Server Management Studio
try {
    choco install sql-server-management-studio -y
    Write-Log "Successfully installed SQL Server Management Studio."
} catch {
    Write-Log "ERROR: Failed to install SQL Server Management Studio."
}

#--- Git
try {
    choco install --force git -y
    Write-Log "Successfully installed git."
} catch {
    Write-Log "ERROR: Failed to install git."
}

#--- Tortoise git
try {
    choco install tortoisegit -y
    Write-Log "Successfully installed Tortoise git."
} catch {
    Write-Log "ERROR: Failed to install Tortoise git."
}

#Refresh Environment Variables
Get-ChildItem Env: | ForEach-Object { $_.Value = [Environment]::GetEnvironmentVariable($_.Name) }
