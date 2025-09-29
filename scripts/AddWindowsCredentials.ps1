Install-Module -Name CredentialManager -Force
New-StoredCredential -Target "90.0.0.20" -UserName "Administrator" -Password "Administrator" -Persist Enterprise -Type DomainPassword
New-StoredCredential -Target "10.0.0.20" -UserName "Administrator" -Password "Administrator" -Persist Enterprise -Type DomainPassword
#New-StoredCredential -Target "90.0.0.20\Public\Trajectories" -UserName "Administrator" -Password "Administrator" -Persist Enterprise
