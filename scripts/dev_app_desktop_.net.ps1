Disable-UAC

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
