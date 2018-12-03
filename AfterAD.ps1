# Making Users
New-ADUser -Name "Young Chen" -DisplayName "Young Chen (ADM)" -SamAccountName "young.chen-adm" -UserPrincipalName "young.chen-adm@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Young Chen" -DisplayName "Young Chen" -SamAccountName "young.chen" -UserPrincipalName "young.chen@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true

# Making Users Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "young.chen-adm"

# Making Reverse Lookup Zone 
Add-DnsServerPrimaryZone -NetworkID "10.0.5.0/24" -ReplicationScope "Forest" 

# Making DNS and PTR Records
Add-DnsServerResourceRecordA -Name "blog01-young" -IPv4Address "10.0.5.20" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fw01-young" -IPv4Address "10.0.5.2" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fs01-young" -IPv4Address "10.0.5.8" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "lin01-young" -IPv4Address "10.0.5.33" -ZoneName "young.local" -CreatePtr

# Renaming Computer 
Rename-Computer -NewName ad01-young

# Restarting Computer
Restart-Computer -Force
