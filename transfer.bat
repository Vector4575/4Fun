@echo off 
echo Transfering Files to Blog Server
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\blog.sh root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\sshd_config root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\wp-config.php root@10.0.5.20:/

echo Transfering Files to DHCP Server
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\dhcp.sh root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\sshd_config root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\Administrator\Desktop\dhcpd.conf root@10.0.5.20:/

echo Done!!
