#Installing AD Role and Features
Install-WindowsFeature AD-Domain-Services,RSAT-ADDS

#Importing Modules 
Import-Module ADDSDeployment

# Making it a DC
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainMode “7” -DomainName “young.local” -DomainNetbiosName “YOUNG” -ForestMode “7” -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$true -SysvolPath “C:\Windows\SYSVOL” -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssword!" -AsPlainText -Force)

# Renaming Computer 
Rename-Computer -NewName ad01-young

# Restarting Computer
Restart-Computer -Force
