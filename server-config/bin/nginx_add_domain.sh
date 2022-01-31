#!/bin/bash
#Script will create basic configuration file for nginx webserver for provided domain name 

if [ $1"x" == "x" ]; then 
  echo "Enter as parameter a domain name"
  exit
fi

#Check if this is domain or subdomain 
num = `expr match $var [.]`
echo "Numbers of the \".\": $num"


#Create folder structure for domain 
# Set space as the delimiter
IFS='.'

#Count the total words
echo "There are ${#strarr[*]} words in the text."
#last two words use as domain 
#remaining use as a subdomains
i=${#strarr[*]}
SUBDOMAIN=""
DOMAIN=""

for val in "${strarr[@]}";
do
  printf "$val\n"
  if [ ${i} -eq 4 ]; then 
    SUBDOMAIN=${val}"."
  elif [ ${i} -eq 3 ]; then 
    SUBDOMAIN=${SUBDOMAIN}${val}
  elif [ ${i} -eq 2 ]; then 
    DOMAIN=${val}"."
  elif [ ${i} -eq 1 ]; then
    DOMAIN=${DOMAIN}${val}
  fi

  i=${i}-1

  echo "Subdoman: " ${SUBDOMAIN}
  echo "Domain:   " ${DOMAIN}
  echo "i: " ${i}
  echo "-----"
done

echo "Subdoman: " ${SUBDOMAIN}
echo "Domain:   " ${DOMAIN}

#Define ROOT-DIR-PATH
# DOMAIN-NAME
# replace those values in sample file 0.sample.conf in nginx.conf.d folder and wrinte it to final file

#Create configuration file for nginx for this domain

#restart nginx
systemctl restart nginx

#sync configuration to remaining server 
rsync_server.sh

echo "Completed"
exit