# Allow remote Scipts 
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force -Verbose

# Adding computer to domain
$domain = "young.local"
$username = "young.chen-adm"
$password = "P@ssword!" | ConvertTo-SecureString -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password
Add-Computer -DomainName $domain -Credential $creds -Restart -Verbose