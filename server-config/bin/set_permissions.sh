#!/bin/bash 
#Script will set exepcted permissions on the file system

chown -R nginx:nginx /data/www/
#All files in web directory should be just readable, no executable allowed in the web directory
# folders allow to access only by owner of running process and group users
# this configuration is suficient for website, there should be no files 777, 666 as those files are open for all to do a changes.
find /data/www -type d -exec chmod 750 {} \;
find /data/www -type f -exec chmod 640 {} \;

#Update persmissions for support user
chown -R support:support /home/support
chmod 700 /home/support/.ssh
chmod 640 /home/support/.ssh/authorized_keys