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

$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$strpos = $helperUri.LastIndexOf("/")
$helperUri = $helperUri.Substring(0, $strpos)
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

$path = 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell'
$key = Get-Item -LiteralPath $path -ErrorAction SilentlyContinue
if ($key -eq $null)
{
    (get-item HKLM:\Software\Policies\Microsoft).OpenSubKey("Windows", $true).CreateSubKey("PowerShell")
}
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "EnableScripts" -Value 00000001 -Type DWORD
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\PowerShell" -Name "ExecutionPolicy" -Value "Unrestricted"

#--- Creating registry key LocalAccountTokenFilterPolicy
# Define the registry path
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
# Ensure the key exists (create if it doesn't)
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Log "Created registry key: $regPath"
}

# CreateLocalAccountTokenFilterPolicy if it doesn't exist and set value to 1
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
    $errorMsg = "Failed to set registry key EnableLUA: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

# Executing Windows Updates
executeScript "WUpdates.ps1";

# Set Maximum Password Age to 0 days (never expires)
try {
    net accounts /maxpwage:unlimited
    Write-Log "Successfully set Maximum Password Age to 0 days (never expires)."
} catch {
    $errorMsg = "Failed to set Maximum Password Age to 0 days (never expires): $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

# Set MinimumPasswordLength = 15 and Enable PasswordComplexity
try {
    $exportPath = "C:\Temp\secpol.cfg"
    if (!(Test-Path "C:\Temp")) {
    	New-Item -Path "C:\Temp" -ItemType Directory | Out-Null
    }
	# Export current local security policy
    secedit /export /cfg $exportPath
	# Modify MinimumPasswordLength and PasswordComplexity
    $content = $content -replace 'MinimumPasswordLength\s*=\s*\d+', 'MinimumPasswordLength = 15'
    $content = $content -replace 'PasswordComplexity\s*=\s*\d+', 'PasswordComplexity = 1'
	# Write updated content back
    Set-Content -Path $exportPath -Value $content
    # Apply the modified security policy
    secedit /configure /db secedit.sdb /cfg $exportPath
	if ($LASTEXITCODE -eq 0) {
        Write-Log "Successfully set MinimumPasswordLength = 15 and enabled PasswordComplexity."
    } else {
          Write-Log "ERROR: Failed to set set MinimumPasswordLength = 15 and enable PasswordComplexity."
    }
    # Remove the temp file
    Remove-Item $exportPath -Force
} catch {
    $errorMsg = "Failed to set set MinimumPasswordLength = 15 and enable PasswordComplexity: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

# Turn Off All Firewall Profiles
try {
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False
    Write-Log "Successfully Turned Off All Firewall Profiles."
} catch {
    $errorMsg = "Failed to Turn Off All Firewall Profiles: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "dev_app_desktop_.net.ps1";
executeScript "browsers.ps1";


#Turning Windows features on
executeScript "EnableWindowsFeatures.ps1";
#Setting PowerOption = Ultimate Performance
executeScript "PowerConfig.ps1";
#Turn off the default RWIN auto tuning behavior(Wago)
executeScript "AutotuningBehavior.ps1"

# Default Printer
try {
    # Disable "Let Windows manage my default printer"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value 1
	# Set "Microsoft Print to PDF" as the default printer
	$printer = "Microsoft Print to PDF"
    (Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Name='$printer'").SetDefaultPrinter()
    Write-Log "Successfully disabled Let Windows manage my default printer and set "Microsoft Print to PDF" as the default printer."
} catch {
    $errorMsg = "Failed to disable Let Windows manage my default printer and set "Microsoft Print to PDF" as the default printer.: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

# Enable Remote Desktop
try {
    # Enable Remote Desktop connections
    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
	# Allow Network Level Authentication (recommended for security)
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1
    (Get-WmiObject -Query "SELECT * FROM Win32_Printer WHERE Name='$printer'").SetDefaultPrinter()
    Write-Log "Successfully disabled Let Windows manage my default printer and set "Microsoft Print to PDF" as the default printer."
	# Enable "Allow Remote Assistance connections to this computer"
	Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 1
	Write-Log "Successfully enabled Remote Desktop Connections."
} catch {
    $errorMsg = "Failed to enable Remote Desktop Connections.: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}

#Add Windows Credential
executeScript "AddWindowsCredentials.ps1";

#--- Disabling UAC
try {
    Set-ItemProperty -Path $regPath -Name EnableLUA -Value 0
    Write-Log "Successfully updated EnableLUA with value 0 in $regPath."
} catch {
    $errorMsg = "Failed to set registry key EnableLUA: $($_.Exception.Message)"
    Write-Log "ERROR: $errorMsg"
}
