#!/bin/bash
#Script will perform instalation of the app and db servers 


#Run main instalation on each server 
echo "Run instalation script"
sudo ${HOME}/bin/02.server-instalation-script-app.sh

#Run DB instalation on app2 and app4 only 

if [ "$HOSTNAME" == *"app2"* ] || [ "$HOSTNAME" == *"app4"* ] ; then
  echo "Run MySQL server instalation "

fi

