#!/bin/bash
sudo su-
yum update -y
yum install httpd -y
yum install git -y
service httpd start 
chkconfig https on
gitclone https://github.com/Nishworl/Website.git >/var/www/html