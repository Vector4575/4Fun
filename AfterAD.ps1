# Making Users
New-ADUser -Name "Young Chen" -DisplayName "Young Chen (ADM)" -SamAccountName "young.chen-adm" -UserPrincipalName "young.chen-adm@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Young W. Chen" -DisplayName "Young Chen" -SamAccountName "young.chen" -UserPrincipalName "young.chen@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Alice" -DisplayName "Alice(DU)" -SamAccountName "alice" -UserPrincipalName "alice@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Bob" -DisplayName "Bob(DU)" -SamAccountName "bob" -UserPrincipalName "bob@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force) -Enabled $true
New-ADUser -Name "Charlie" -DisplayName "Charlie(DU)" -SamAccountName "charlie" -UserPrincipalName "charlie@young.local" -AccountPassword(ConvertTo-SecureString -AsPlainText "P@ssword!" -Force)

# Making Users Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "young.chen-adm"

# Making Reverse Lookup Zone 
Add-DnsServerPrimaryZone -NetworkID "10.0.5.0/24" -ReplicationScope "Forest" 

# Making DNS and PTR Records
Add-DnsServerResourceRecordA -Name "blog01-young" -IPv4Address "10.0.5.20" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fw01-young" -IPv4Address "10.0.5.2" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "fs01-young" -IPv4Address "10.0.5.8" -ZoneName "young.local" -CreatePtr
Add-DnsServerResourceRecordA -Name "lin01-young" -IPv4Address "10.0.5.33" -ZoneName "young.local" -CreatePtr

# Tranferring files to Blog server 
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\blog.sh root@10.0.5.20:/
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\sshd_config root@10.0.5.20:/
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\wp-config.php root@10.0.5.20:/

# Transferring Files to DHCP Server
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\dhcp.sh root@10.0.5.33:/
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\sshd_config root@10.0.5.33:/
.\pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\dhcpd.conf root@10.0.5.33:/

# Running blog.sh
.\putty.exe -ssh root@10.0.5.20 -pw Ch@mpl@1n!18 -m .\cblog.txt

#  Running dhcp.sh
.\putty.exe -ssh root@10.0.5.33 -pw Ch@mpl@1n!18 -m .\cdhcp.txt

#Joining Windows computer to domain. 
Set-Item WSMan:\localhost\Client\TrustedHosts\ -Value "*"
Enable-PSRemoting -Force
winrm quickconfig -quiet
netsh advfirewall set allprofiles state off

# creds of workstation user
$username = "young"
$password = "P@ssword!" | ConvertTo-SecureString -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

# creds of domain admin
$username1 = "YOUNG\young.chen-adm"
$password1 = "P@ssword!" | ConvertTo-SecureString -AsPlainText -Force
$creds1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username1,$password1

# creds of file server user
$username2 = "Administrator"
$password2 = "P@ssword!" | ConvertTo-SecureString -AsPlainText -Force
$creds2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username2,$password2

# Adding workstation to domain 
Add-Computer -ComputerName "wks01-young" -LocalCredential $creds -DomainName "young" -Credential $creds1 -Restart -Force

# Installing Features on FS01
Install-WindowsFeature FS-Resource-Manager
Install-WindowsFeature -ComputerName fs01-young -Name File-Services,FS-FileServer,FS-Resource-Manager -IncludeManagementTools -Credential $creds2

# Creating Share 
Invoke-Command -ComputerName fs01-young -ScriptBlock {New-Item -Path "C:\SYS255" -ItemType Directory}
Invoke-Command -ComputerName fs01-young -ScriptBlock {New-SmbShare -Name "SYS255" -Path "C:\SYS255"}
Invoke-Command -ComputerName fs01-young -ScriptBlock {New-Item -Name "testfile.txt"-Path "C:\SYS255" -ItemType File -Value "This was scripted"}

# Adding file server to domain 
Add-Computer -ComputerName "fs01-young" -LocalCredential $creds2 -DomainName "young" -DomainCredential $creds1 -Restart -Force

# Renaming Computer 
Rename-Computer -NewName ad01-young

#Restart Server 
Restart-Computer -Force
