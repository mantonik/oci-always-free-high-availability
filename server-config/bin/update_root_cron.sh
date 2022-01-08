#!/bin/bash

#Script will udpate root.cron 
echo $HOME/cron/root.cron > /tmp/root.cron
echo $HOME/cron/root.cron.custom >> /tmp/root.cron
sudo crontab /tmp/root.cron
rm /tmp/root.cron 
echo "---------------------------"
sudo crontab -l
echo ""
echo "---------------------------"