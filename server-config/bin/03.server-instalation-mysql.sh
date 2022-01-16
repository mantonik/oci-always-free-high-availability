#!/bin/bash
# #Script is executed as root user

LOGFILE=/root/log/mysql.setup.log

##################
# FUNCTION
##################
function mysql_create_repusr() {

  mysql -u root -e "CREATE USER 'repusr'@'10.10.1.0/24' IDENTIFIED BY '${REPUSRMYQLP}';" 
  mysql -u root -e "GRANT REPLICATION SLAVE, REPLICATION_SLAVE_ADMIN, SUPER, REPLICATION CLIENT ON *.* TO 'repusr'@'10.10.1.0/24';" 
  mysql -u root -e "FLUSH PRIVILEGES ;"
  mysql -u root -e "flush logs;"

  MASTER_STATUS_FILE=/share/mysql_${HOSTNAME: -4}_master_status.txt
  mysql -u root -e "show master status;" > ${MASTER_STATUS_FILE}
  sed -e 's/\t/ /g' -i ${MASTER_STATUS_FILE}
  chmod 644 ${MASTER_STATUS_FILE}


}


function mysql_set_replication (){
  #BINLOG_STATUS_FILE=$1
  echo "'"
  echo "--- Set replication - app4"
  echo "'"

  export APP2_HOSTNAME=${HOSTNAME::-1 }"2"
  echo "APP2_HOSTNAME: " ${APP2_HOSTNAME}


  BINLOG_LINE=`cat /mnt/share_app2/mysql_app2_master_status.txt |grep "binlog."`
  BINLOG_FILE=${BINLOG_LINE:0:13}
  BINLOG_POSITION=${BINLOG_LINE:14}
  echo ${BINLOG_FILE}
  echo ${BINLOG_POSITION}
  echo ${REPUSRMYQLP}


mysql -u root -e "CHANGE REPLICATION SOURCE TO
SOURCE_HOST='${APP2_HOSTNAME}',
SOURCE_USER='repusr',
SOURCE_PASSWORD='${REPUSRMYQLP}',
SOURCE_LOG_FILE='${BINLOG_FILE}',
SOURCE_LOG_POS=${BINLOG_POSITION};
start slave;
show slave status\G;
"
sleep 5
mysql -u root  -e "show slave status\G;"


  echo ""
  echo "set replication app2"

  BINLOG_LINE=`cat /share/mysql_app4_master_status.txt |grep "binlog."`
  BINLOG_FILE=${BINLOG_LINE:0:13}
  BINLOG_POSITION=${BINLOG_LINE:14}
  echo ${BINLOG_FILE}
  echo ${BINLOG_POSITION}
  echo ${REPUSRMYQLP}
  echo ${APP2_HOSTNAME}

mysql -u repusr  -p${REPUSRMYQLP}  -h ${APP2_HOSTNAME} -e "stop slave;
CHANGE REPLICATION SOURCE TO
SOURCE_HOST='${HOSTNAME}',
SOURCE_USER='repusr',
SOURCE_PASSWORD='${REPUSRMYQLP}',
SOURCE_LOG_FILE='${BINLOG_FILE}',
SOURCE_LOG_POS=${BINLOG_POSITION};
start slave;
show slave status\G;
"
sleep 5
mysql -u repusr  -p${REPUSRMYQLP}  -h ${APP2_HOSTNAME} -e "show slave status\G;"


#set replication on the app2 server 




}


function mysql_set_root_password(){
  echo "Set MySQL Root Passowrdś"
}


##################
# Main
##################

ś
#Install MySQL on app2 and app4
if [ "$HOSTNAME" == *"app1"* ] || [ "$HOSTNAME" == *"app3"* ] ; then
  echo "This is not Desing to run on app1 or app3"
  echo "Please run this script on app2 and app4 for MySQL instance"
  exit
fi

echo "Host app2 or app4 - install MySQL"
dnf install -y mysql-server 
#Update configuration of the server 
echo "server-id="${HOSTNAME: -1} >> /etc/my.cnf.d/mysql-server.cnf
echo "----"
echo "mysql-server.cnf file"
cat /etc/my.cnf.d/mysql-server.cnf

echo "Start MySQLD"
systemctl start mysqld

#Installing on server 2
#Generate root and usrrep passwrod and put files on share point and in root file 
# .private 
# .private/my.p
# root:PASSWORD
# repusr:PASSWORD

#Create random string for root and repusr
echo "Create .private folder to store root password"
mkdir ~/.private
chmod 700 ~/.private

#rm -f /share/.my.p

#Run this only on app2 server
echo "Exeucte on specific server"
if [ "$HOSTNAME" == *"app2"* ]; then 

  echo "Execute on app2 server"

  echo "Generate root and repusr password"
  ROOTMYQLP=`tr -dc A-Za-z0-9 </dev/urandom | head -c 20`
  ROOTMYQLP="${ROOTMYQLP:1:8}1Yk"
  REPUSRMYQLP=`tr -dc A-Za-z0-9 </dev/urandom | head -c 20`
  REPUSRMYQLP="${REPUSRMYQLP:6:8}4hD"

  echo "root:${ROOTMYQLP}" > ~/.private/.my.p
  echo "repusr:${REPUSRMYQLP}" >> ~/.private/.my.p
  chmod 400 ~/.private/.my.p

  cp ~/.private/.my.p /share
  chmod 444 /share/.my.p
  cat /share/.my.p

  echo "Execute create repusrś"
  mysql_create_repusr

elif [ "$HOSTNAME" == *"app4"* ]; then 
  echo "Exeucte on app4 server"
  #Create copy of the password file 
  cp /mnt/share_app2/.my.p ~/.private
  chmod 400 ~/.private/.my.p

  #Read slave passwrod from share drive
  export REPUSRMYQL=`cat /mnt/share_app2/.my.p|grep repusr`
  export REPUSRMYQLP=${REPUSRMYQL:7}
  echo "REPUSRMYQL: "${REPUSRMYQL}
  echo "REPUSRMYQLP: "${REPUSRMYQLP}

  #Craete replication user
  mysql_create_repusr

  #Set replication on app4
  mysql_set_replication

 

  #Delete password file from share point
else
  echo "Error - script executed on wrong server, please delete MySQL from this server"
fi


#   mysql -u root -e "select user,host from mysql.user;"
#   mysql -u root -e "stop slave; start slave;show slave status\G;"
#   mysql -u root -e "show slave status\G;"
#   mysql -u repusr -p${REPUSRMYQLP} -h demoapp2
# mysql -u repusr -p${REPUSRMYQLP} -h demoapp4



