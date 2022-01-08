#!/bin/bash
#

#Install MySQL on app2 and app4

if [ "$HOSTNAME" == *"app1"* ] || [ "$HOSTNAME" == *"app3"* ] ; then
  echo "This is not Desing to run on app1 or app3"
  echo "Please run this script on app2 and app4 for MySQL instance"
  exit
fi

echo "Host app2 or app4 - install MySQL"
dnf install -y mysql-server 
systemctl mysqld start 

