#!/bin/bash 
# run below commands to start instalation on servers 

app1
wget https://raw.githubusercontent.com/mantonik/oci-always-free-high-availability/main/server-config/oci-server-initial-cloud-script.sh
chmod 750 oci-server-initial-cloud-script.sh
./oci-server-initial-cloud-script.sh

app2
app3
app4 

export https_proxy=http://10.10.1.11:3128; wget https://raw.githubusercontent.com/mantonik/oci-always-free-high-availability/main/server-config/oci-server-initial-cloud-script.sh
chmod 750 oci-server-initial-cloud-script.sh
./oci-server-initial-cloud-script.sh