#!/bin/bash 

#Script will sync from repository to local 
export REPO=dev-2
export REPODIR=${HOME}/repository/${REPO}
export https_proxy=http://10.10.1.11:3128;
export http_proxy=http://10.10.1.11:3128;

cd ${REPODIR}
wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/${REPO}.zip
rm -rf oci-always-free-high-availability-${REPO}
unzip ${REPO}.zip
cp -a oci-always-free-high-availability-${REPO}/server-config/* ${HOME}/
cd ${HOME}
ls -l
