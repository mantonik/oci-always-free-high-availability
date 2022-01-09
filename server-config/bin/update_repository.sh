#!/bin/bash 
# 
# 1/8/2022 add delete local repository before pulling from repo
#
#Script will sync from repository to local 
export REPO=dev-2
export REPODIR=${HOME}/repository/${REPO}
export https_proxy=http://10.10.1.11:3128;
export http_proxy=http://10.10.1.11:3128;

# Delete repo folder
rm -rf ${REPODIR}
mkdir -p ${REPODIR}
cd ${REPODIR}
# upload repo file
wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/${REPO}.zip
unzip ${REPO}.zip
# echo copy to home
cp -a oci-always-free-high-availability-${REPO}/server-config/* ${HOME}/
cd ${HOME}
ls -l
