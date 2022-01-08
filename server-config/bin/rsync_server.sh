#!/bin/bash 
# script will sync configuration file with server 
#
# 1.0 1/8/2022 Initial version
#
echo ""
echo "Rsync configuration folder wtih root file system"
rsync -rltDv --no-owner /home/opc/configuration/ /

#Secure critical configuration 
chown root:root /etc/sudoers.d

echo "--- Completed ---"
echo ""
# END
