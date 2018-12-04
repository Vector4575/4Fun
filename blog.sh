echo "Restarting NIC"
systemctl restart network

echo "Creating User and making it admin"
useradd young
echo -e "P@ssword!\nP@ssword!" | passwd young
usermod -aG wheel young

echo "Installing Tree"
yum -y install tree

echo "Installing Packages for Joining Windows Domain"
yum -y install realmd samba samba-common oddjob oddjob-mkhomedir sssd

echo "Joining Windows Domain"
echo -e "P@ssword!" | realm join --user=young.chen@young.local young.local

echo "Copying SSHD Config File"
cp /sshd_config /etc/ssh/sshd_config

echo "Installing HTTP" 
yum -y install httpd

echo "Starting HTTP" 
systemctl enable httpd
systemctl start httpd

echo "Installing Maria DB"
yum -y install mariadb-server mariadb

echo "Starting MariaDB"
systemctl enable mariadb
systemctl start mariadb

echo "Securing MariaDB"
mysql_secure_installation << EOF

y
P@ssword!
P@ssword!
y
y
y
y
EOF

echo "Installing PHP"
yum -y install php php-mysql

echo "Restarting HTTP to load new configs"
systemctl restart httpd

echo "Setting Firewall Rules"
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

echo "Reloading Firewall"
firewall-cmd --reload

echo "Logging into MySQL"
mysql -u root -pP@ssword! -e "CREATE DATABASE wordpress; CREATE USER young@localhost IDENTIFIED BY 'P@ssword!'; GRANT ALL PRIVILEGES ON wordpress.* TO young@localhost IDENTIFIED BY 'P@ssword!'; FLUSH PRIVILEGES; exit"

echo "Obtaining WordPress"
yum -y install php-gd
systemctl restart httpd
cd ~
wget http://wordpress.org/latest.tar.gz

echo "Unzipping Wordpress Install"
tar xzvf latest.tar.gz

echo "Moving Files"
rsync -avP ~/wordpress/ /var/www/html/

echo "Making uploads directory"
mkdir /var/www/html/wp-content/uploads

echo "Changing File Perms"
chown -R apache:apache /var/www/html/*

echo "Making config file"
cd /var/www/html
cp /wp-config.php /var/www/html/wp-config.php
