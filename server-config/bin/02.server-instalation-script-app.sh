#!/bin/bash
# Instalation script for application servers

# Version 
# 12/27/2021 
# 1/3/2022 - change start of squid after instaltion from restart -> start
#  add note for server app1
# delete proxy entry fron dnf file
# update envirement proxy values
# add mc
# add coments to install mysql on app2,4
# add a variable for supportsshkey
# fixif condition fo rapp2, app4
# 1/8/2022 Mariusz - add reference to scripts which will perform isntalation
#   fix name of the sshd_config file
##################
#Parameters 
##################

SUPORTPASS="OciSupp0rt6758\)"
ROOTPASS="Edchjuy784576\&"
#SUPPORTPUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEKd3NF56oAnOJMRGmGd/XLia2lSP6CHzXVW2adHhqo0znA8F6D3EBFAGyBPkp9N+6lfPVNNTdkRaxAdn6Lcy1aHQCTjCL1jbtbZHc3/nD5tIAeZuqb5c3uurHTRaqQSYxGvkSbBtFJfOEbatvO110VS7oE58CvEuAZTdE1czGQB/lg8xdnDvWcXDxyNvmYA8AdbwXAf/26KqIaawkTpE5VTdL1Ud2M81vnBHI5AwANZugdYiw2Y1ztKhScLSHdGtvx8nR409kk1NcDKliI6IZa9Z5Ox4WQlZiGsoy6uQ13CYEm4B+F8qg2OWE7yoLqxxnnj539q6FIozGo8A/jdDvnemdG6B7xaXeCWY4DesShpm/xacWUGfjVeSPU4NC/Appn5Y/G0AkNQ6359Ha8xT0Wep7LFUWMHaQWIGnL3hlgT+jwC88uIxwih8JM+O5HKprtnnEtlEBkuhRzcmT77DL14i8BFcNvLS2/BBlA+BYgCqR7ADD7K092xNt6aLQc6snkyGHI2OK9gLp9+/lWt/SvYX9cAVpPjaHNJ7quxH7PYQ/T3p3FwaPVSHg76fX0j/TMqevrjdG5lSsu+Mh44UsMfEymJJgP5LZSzzWPLM7Ol3BwbTRKhbsVzdaV+VVCtVgPPIY1n5vWwTsEfMtXEGaVVoOUftZgu/3+ZBwGCq/OQ== mariusz@mac"
#########

DT=`date +%Y%m%d`

#disable firewall
systemctl disable firewalld
systemctl stop firewalld

#Create user and set support user 
groupadd -g 1099 support
useradd -u 1099 -g 1099 support
usermod -G adm support

#Add user opc to nginx group
usermod -G opc nginx


#Chagne support user passwrod
echo ${SUPORTPASS} | passwd --stdin support

#Change root passwrod
echo ${ROOTPASS} | passwd --stdin root

#add sudo access to support user 


#delete proxy entry from dnf config file
sed -i '/^proxy=http/d' /etc/dnf/dnf.conf

echo "Hostname: $HOSTNAME"
if [[ "$HOSTNAME" == *"app1"* ]]; then
  echo "Execute configuration for app1 server"
  #Oracle Linux
  
  dnf -y update
  dnf install -y oraclelinux-release-el8
  dnf config-manager --set-enabled ol8_developer_EPEL
  dnf clean all 

  echo "This is app1 servers, install squid."
  dnf -y install squid
  chkconfig squid on
  echo "Restart squid"
  systemctl stop squid
  systemctl start squid

  #Update dnf.conf file - add proxy line
  echo "proxy=http://10.10.1.11:3128" >>  /etc/dnf/dnf.conf
  echo "" >>  /etc/dnf/dnf.conf
else 
  #Update dnf.conf file - add proxy line, All servers need to connect throw proxy server
  echo "proxy=http://10.10.1.11:3128" >>  /etc/dnf/dnf.conf
  echo "" >>  /etc/dnf/dnf.conf
  dnf -y update
  dnf install -y oraclelinux-release-el8
  dnf config-manager --set-enabled ol8_developer_EPEL
  dnf clean all 
fi


echo "Install required packages"
dnf install -y nginx php php-fpm php-mysqlnd php-json
dnf install -y sendmail htop tmux mc rsync clamav clamav-update 


#Setup web folder structure
mkdir -p /data/www/default/htdocs
dnf module list php
dnf -y module reset php
#set php 7.4 as default 
dnf -y module enable php:7.4
dnf module list php


#PHP configuration 
echo "#Enable mysqli extension" >> /etc/php.ini
echo "extension=mysqli" >> /etc/php.ini
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf


#If servers are app2 and app4 - install MySQL 
mv /usr/share/nginx/html/* /data/www/default/htdocs
rm -fr /usr/share/nginx/html
ln -s /data/www/default/htdocs /usr/share/nginx/html
rm -f /data/www/default/htdocs/index.html

#Backup original configuration 
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.${DT}

#set local time 
timedatectl set-timezone America/New_York

#Execute rsync process
/home/opc/bin/rsync_server.sh

#Set permissions for file system
/home/opc/bin/set_permissions.sh

#set root crontab 
/home/opc/bin/update_root_cron.sh

#set services to start automaticly
chkconfig nginx on
chkconfig sendmail on
chkconfig php-fpm on

# restart services
/home/opc/bin/restart_services.sh


date
date >> /tmp/instalation-script.txt
echo "Instalation script completed " >> /tmp/instalation-script.txt

#test website up
echo "-----"
curl http://localhost/test.html
echo "-----"
curl http://localhost/test.php
echo "-----"
curl http://localhost/health-check.php
exit