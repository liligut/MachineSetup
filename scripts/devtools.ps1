# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

choco install --cacheLocation="$ChocoCachePath" -y cpu-z
choco install --cacheLocation="$ChocoCachePath" -y coretemp
choco install --cacheLocation="$ChocoCachePath" dotnetfx
choco install --cacheLocation="$ChocoCachePath" -y vscode
choco install --cacheLocation="$ChocoCachePath" -y sysinternals
choco install --cacheLocation="$ChocoCachePath" beyondcompare
choco install --cacheLocation="$ChocoCachePath" putty
choco install sql-server-express -o -ia "'/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER /UPDATEENABLED=FALSE'" -y
#choco install mssqlexpress2014sp1wt -params "'/INSTANCEID=MSSQLSERVER /INSTANCENAME=MSSQLSERVER'" -y
#choco install sql-server-management-studio
choco install --cacheLocation="$ChocoCachePath" adobereader
choco install --cacheLocation="$ChocoCachePath" microsoft-windows-terminal
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
