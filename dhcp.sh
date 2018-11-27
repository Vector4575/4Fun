echo "Restarting NIC"
systemctl restart network

echo "Creating User and making it admin"
useradd young
echo -e "P@ssword!\nP@ssword!" | passwd young
usermod -aG wheel young

echo "Installing Packages for Joining Windows Domain"
yum -y install realmd samba samba-common oddjob oddjob-mkhomedir sssd

echo "Joining Windows Domain"
echo -e "P@ssword!" | realm join --user=young.chen@young.local young.local

echo "Copying SSHD Config File"
cp /sshd_config /etc/ssh/sshd_config

echo "Installing DHCP"
yum -y install dhcp

echo "Moving over Config File"
cp /dhcpd.conf /etc/dhcp/dhcpd.conf

echo "Starting DHCP"
systemctl enable dhcpd
systemctl start dhcpd

echo "Adding Firewall Rules for DHCP"
firewall-cmd --permanent --add-service=dhcp

echo "Reloading Firewall" 
firewall-cmd --reload

