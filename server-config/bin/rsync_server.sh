#!/bin/bash 
# script will sync configuration file with server 
#
# 1.0 1/8/2022 Initial version
#
echo ""
echo "Rsync configuration folder wtih root file system"
rsync -atv /home/opc/configuration/ /
echo "--- Completed ---"
echo ""
# END
