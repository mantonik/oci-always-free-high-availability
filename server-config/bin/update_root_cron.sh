#!/bin/bash
#
# Version
# 1.0 - 1/8/2022 Initial version
# 1.1 - add check for root.cron.custom 
#
###################################################
#Script will udpate root.cron 
echo /home/opc/cron/root.cron > /tmp/root.cron
if [ -e /home/opc/cron/root.cron.custom ]; then
  echo /home/opc/cron/root.cron.custom >> /tmp/root.cron
fi 
sudo crontab /tmp/root.cron
rm /tmp/root.cron 
echo "---------------------------"
sudo crontab -l
echo ""
echo "---------------------------"
# end 
