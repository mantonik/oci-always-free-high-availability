to copy complete repository, and use process base on zip 
#wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/main.zip

Run below comands on respective servers as OPC user 

##########
APP1
##########

export REPO=dev 
REPODIR=${HOME}/repository/${REPO}
cd ${HOME}
rm -rf * 
mkdir -p ${REPODIR}
cd ${REPODIR}
wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/${REPO}.zip
unzip ${REPO}.zip
cp -a oci-always-free-high-availability-${REPO}/server-config/* ${HOME}/
cd ${HOME}
ls -l

./bin/01.install-server-4app-2db.sh

#########
APP 2,3,4
#########

export REPO=dev 
export REPODIR=${HOME}/repository/${REPO}
export https_proxy=http://10.10.1.11:3128;
export http_proxy=http://10.10.1.11:3128;
cd ${HOME}
rm -rf * 
mkdir -p ${REPODIR}
cd ${REPODIR}
wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/${REPO}.zip
unzip ${REPO}.zip
cp -a oci-always-free-high-availability-${REPO}/server-config/* ${HOME}/
cd ${HOME}
ls -l

./bin/01.install-server-4app-2db.sh

#########




For support requests allow SSH access from IP:  107.150.23.152

