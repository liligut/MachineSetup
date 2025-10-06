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

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

#--- Tools ---
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022professional
#choco install -y visualstudio2019professional
Update-SessionEnvironment #refreshing env due to Git install

#--- SDKs ---
choco install --cacheLocation="$ChocoCachePath" dotnetcore-sdk
choco install --cacheLocation="$ChocoCachePath" dotnet3.5
choco install --cacheLocation="$ChocoCachePath" dotnet
choco install --cacheLocation="$ChocoCachePath" dotnet-5.0-sdk

#--- Workloads ---
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-manageddesktop
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-manageddesktopbuildtools
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2022-workload-nativedesktop
#choco install --cacheLocation="$ChocoCachePath" -y visualstudio2019-workload-netcoretools

#--- reenabling critial items ---
#Enable-UAC
#Enable-MicrosoftUpdate
#Get-WindowsUpdate -acceptEula

#--- Creating registry key LocalAccountTokenFilterPolicy
# Define the registry path
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
# Ensure the key exists (create if it doesn't)
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Log "Created registry key: $regPath"
}
# Create the DWORD value if it doesn't exist, or set it to 1
try {
    New-ItemProperty -Path $regPath -Name "LocalAccountTokenFilterPolicy" -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Log "Successfully created/updated 'LocalAccountTokenFilterPolicy' with value 1 in $regPath."
} catch {
    $errorMsg = "Failed to set registry key LocalAccountTokenFilterPolicy: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

#--- Disabling UAC
try {
    Set-ItemProperty -Path $regPath -Name EnableLUA -Value 0
    Write-Log "Successfully updated EnableLUA with value 0 in $regPath."
} catch {
    $errorMsg = "Failed to set registry key LocalAccountTokenFilterPolicy: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

#--- SQL Server Management Studio
choco install sql-server-management-studio -y

#--- Tortoise git
choco install tortoisegit -y

#--- Git
choco install --force git -y
