#!/bin/bash 
#Script will generate ssl certificate for provided domain.


echo "Enter your domain name to create let's encrypt certificagte: "
read DOMAIN
echo "Eneter your email address for let's encrypt account registration"
read EMAIL


rm /etc/letsencrypt/

#Register account 
#ask user for email
/usr/local/bin/certbot register -m mantonik@gmail.com  --agree-tos


/usr/local/bin/certbot certonly --webroot -w /data/www/default/htdocs -d ocidemo.ddns.net

export LB_OCIID="ocid1.loadbalancer.oc1.iad.aaaaaaaavl7ihlzsqcun4ojqj2nqk63siudt3c5aodazvhstb3v4cy46xtya"
export CERT_DT=`date +%Y%m%d%H%M`
cd /etc/letsencrypt/live/ocidemo.ddns.net
oci lb certificate create --certificate-name ocidemo.ddns.net.${CERT_DT} \
--load-balancer-id  ${LB_OCIID} \
--ca-certificate-file cert.pem  \
--private-key-file privkey.pem  \
--public-certificate-file fullchain.pem

#Update LB listener to use new certificate 
sleep 120 # it takes minute or two for create certificate - may need also a query to list current available certificates
oci lb listener update \
--default-backend-set-name bk-http \
--port 443 \
--protocol HTTP \
--load-balancer-id ${LB_OCIID} \
--listener-name LS-https \
--ssl-certificate-name ocidemo.ddns.net.${CERT_DT} \
--routing-policy-name RP_LS_HTTPS \
--force

#chck if certificate is updated

oci lb load-balancer get --load-balancer-id ${LB_OCIID}| jq -r '.data.listeners'




#get list of old certificates
#https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.4.4/oci_cli_docs/cmdref/lb/certificate/list.html
#oci lb certificate list --load-balancer-id ${LB_OCIID}
oci lb certificate list --load-balancer-id ${LB_OCIID}|grep  certificate-name |grep -v ocidemo.ddns.net.${CERT_DT}| \
jq -r '.data.listeners'

#oci lb certificate list --load-balancer-id ${LB_OCIID}|grep  certificate-name |grep -v ocidemo.ddns.net.${CERT_DT}|cut -d: -f2


#https://docs.oracle.com/en-us/iaas/tools/oci-cli/3.4.4/oci_cli_docs/cmdref/lb/certificate/delete.html 
oci lb certificate delete
--certificate-name 
--load-balancer-id ${LB_OCIID}




/usr/local/bin/certbot --help

#renew certificate script

#auto update OCI LB wtih new SSL certificate

#renew certificate

certbot renew --deploy-hook ./oci-lb-cert-renewal.sh

oci-lb-cert-renewal.sh 

1. Creates a cert bundle with the newly procured certificate from Let''s Encrypt at the LB.
2. Updates the Listener (oci lb listener update) with this bundle.

oci lb listener update
listener LS-https
--default-backend-set-name, --port, --protocol, --load-balancer-id, --listener-name



3. Deletes (clean-up) any old certificate bundle from the LB (oci lb certificate delete).


listener LS-https
oci lb listener update)

