#!/bin/bash 
# script will sync configuration file with server 
#
# 1.0 1/8/2022 Initial version
# 1.1 add sync permissions, add update root crontab
#
version=1.1


# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi


echo ""
echo "Rsync configuration folder wtih root file system"
rsync -rltDv --no-owner /home/opc/configuration/ /

/home/opc/bin/set_permissions.sh

#update root crontab 
/home/opc/bin/update_root_cron.sh

echo "--- Completed ---"
echo "----------------------"
echo "Version: ${version}"
echo "----------------------"
# END
 