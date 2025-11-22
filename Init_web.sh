#! /bin/bash

setenforce 0

dnf install -y wget tar httpd php php-gd php-opcache php-mysqlnd lynx

wget https://ko.wordpress.org/wordpress-6.8.3-ko_KR.tar.gz
tar xvfz wordpress-6.8.3-ko_KR.tar.gz 

cp -ar wordpress/* /var/www/html/
chown -R apache:apache /var/www/html/

sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/httpd/conf/httpd.conf

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/username_here/wp_user/g' /var/www/html/wp-config.php
sed -i 's/password_here/WpPass1234!/g' /var/www/html/wp-config.php
sed -i 's/localhost/10.0.4.4/g' /var/www/html/wp-config.php

echo $HOSTNAME > /var/www/html/health.html 

systemctl enable --now httpd
dnf install -y firewalld
systemctl enable --now firewalld
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload