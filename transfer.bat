@echo off 
echo Transfering Files to Server
pscp.exe -pw Ch@mpl@1n!18 C:\Users\young.chen\Desktop\wp.sh root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\young.chen\Desktop\sshd_config root@10.0.5.20:/
pscp.exe -pw Ch@mpl@1n!18 C:\Users\young.chen\Desktop\wp-config.php root@10.0.5.20:/
echo Done!!