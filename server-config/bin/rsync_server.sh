#!/bin/bash 
# script will sync configuration file with server 
#
# 1.0 1/8/2022 Initial version
# 1.1 add sync permissions, add update root crontab
#
echo ""
echo "Rsync configuration folder wtih root file system"
rsync -rltDv --no-owner /home/opc/configuration/ /

/home/opc/bin/set_permissions.sh

#update root crontab 
/home/opc/bin/update_root_cron.sh

echo "--- Completed ---"
echo ""
# END
 