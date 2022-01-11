Script is desing to install application to run Nginx, PHP, MySQL server on set of 4 servers in OCI Cloud.

Run below comands on respective servers as OPC user 
SErver name has should be name like 

somethingappX

...app1
...app2
...app3
...app4

##########
app1
##########

export REPO=dev-2
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

sudo ./bin/01.install-server-4app-2db.sh

###########################
app2, app3, app4
###########################

export REPO=dev-2
export REPODIR=${HOME}/repository/${REPO}
export https_proxy=http://10.10.1.11:3128;
export http_proxy=http://10.10.1.11:3128;
. /etc/profile
cd ${HOME}
rm -rf * 
mkdir -p ${REPODIR}
cd ${REPODIR}
wget https://github.com/mantonik/oci-always-free-high-availability/archive/refs/heads/${REPO}.zip
unzip ${REPO}.zip
cp -a oci-always-free-high-availability-${REPO}/server-config/* ${HOME}/
cd ${HOME}
ls -l
sudo /home/opc/bin/01.install-server-4app-2db.sh

#########




For support requests allow SSH access from IP:  107.150.23.152

# on app1 servers set ntfs share drive which will be mounted on other server for instalation purpose.
# this way repository need to be sync only to single server app1 not rest of the servers.
#
# rclone for mounting remote drives like google drive for backup purpose.
#
#
#
