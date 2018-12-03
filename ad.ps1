# Renaming Computer 
Rename-Computer -NewName ad01-young

#Installing AD Role and Features
Install-WindowsFeature AD-Domain-Services,RSAT-ADDS

#Importing Modules 
Import-Module ADDSDesployment

# Making it a DC
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainMode “7” -DomainName “young.local” -DomainNetbiosName “YOUNG” -ForestMode “7” -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$true -SysvolPath “C:\Windows\SYSVOL” -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssword!" -AsPlainText -Force)

# Making Users
New-ADUser -Name "Young Chen" -DisplayName "Young Chen (ADM)" -SamAccountName "young.chen-adm" -UserPrincipalName "young.chen-adm@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Young Chen" -DisplayName "Young Chen" -SamAccountName "young.chen" -UserPrincipalName "young.chen@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true

# Making Users Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "young.chen-adm"

# Making DNS and PTR Records
Add-DnsServerResourceRecordA -Name "blog01-young" -IPv4Address "10.0.5.20" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fw01-young" -IPv4Address "10.0.5.2" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fs01-young" -IPv4Address "10.0.5.8" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "lin01-young" -IPv4Address "10.0.5.33" -ZoneName "young.local" -CreatePtr