#! /bin/bash

setenforce 0

dnf install -y mysql-server
systemctl enable --now mysqld

mysql -uroot -e "
CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'10.0.2.0/24' IDENTIFIED BY 'WpPass1234!';
CREATE USER 'wp_user'@'10.0.3.0/24' IDENTIFIED BY 'WpPass1234!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'10.0.2.0/24';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'10.0.3.0/24';
FLUSH PRIVILEGES;
"

sed -i 's/^bind-address/#bind-address/' /etc/my.cnf
systemctl restart mysqld

dnf install -y openssh-server firewalld
systemctl enable --now sshd firewalld

firewall-cmd --add-service=ssh --permanent
firewall-cmd --add-port=3306/tcp --permanent

firewall-cmd --reload
firewall-cmd --add-service=ssh
firewall-cmd --reload