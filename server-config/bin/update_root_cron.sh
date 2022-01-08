#!/bin/bash



#Script will udpate root.cron 
echo /home/opc/cron/root.cron > /tmp/root.cron
if 
echo /home/opc/cron/root.cron.custom >> /tmp/root.cron
sudo crontab /tmp/root.cron
rm /tmp/root.cron 
echo "---------------------------"
sudo crontab -l
echo ""
echo "---------------------------"