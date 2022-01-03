#!/bin/bash
# script will perform inital configuration and download setup file
#
# Version 
# 1.1 - add list of files to download
#

mkdir bin 
cd bin 
sudo dnf install -y wget 
cd bin 

#download instalation files 
wget https://raw.githubusercontent.com/mantonik/oci-always-free-high-availability/main/server-config/bin/02.server-instalation-script-app.sh

chmod 750 *.sh


