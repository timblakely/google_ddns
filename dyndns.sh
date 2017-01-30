#!/bin/sh
# DynDNS Updater Script, with HTTPS/SSL Support
# This example uses NameCheap's HTTPS/SSL URL update method to update the IP for hostname.example.com. This script runs in an endless loop set to the UPDATE_INTERVAL which is currently 5 minutes.
# Edit the settings section to match your DynDNS provider, including the DDNS URL which will be unique for each provider.
# This script requires curl and its CA Bundle to be installed in /opt/usr/bin, see the DynDNS article for more information.
# alfer@fusebin.com

DYNDNS_SECRETS=/opt/var/dyndns_secrets                                                                                                                 
                                                                                                                                                       
### SETTINGS SECTION ###                                                                                                                               
UPDATE_INTERVAL=300                                                                                                                                 
source "${DYNDNS_SECRETS}"  
DDNS_URL="https://$DDNS_USERNAME:$DDNS_PASSWORD@domains.google.com/nic/update?hostname=$DDNS_HOSTNAME.$DDNS_DOMAIN"

LOG_FILE=/var/log/dyndns.log
CURL_LOG_FILE=/var/log/curl.log
CURL_LOCATION=/usr/bin/curl
CA_BUNDLE_DIR=/opt/etc/ssl/certs

### END SETTINGS SECTION

while sleep $UPDATE_INTERVAL
do 
	CURRENT_TIME=`date`
	CURRENT_WAN_IP=$(curl -s http://canhazip.com) 
	LAST_WAN_IP=`nvram get wan_ipaddr_last`
	DNS_IP=`nslookup $DDNS_HOSTNAME.$DDNS_DOMAIN 8.8.8.8 | grep Address | tail -n 1 | awk '{print $3}'`
	DDNS_UPDATE_COMMAND="$CURL_LOCATION -o $CURL_LOG_FILE -d '' --capath $CA_BUNDLE_DIR '$DDNS_URL&myip=$CURRENT_WAN_IP'"

        # Check if IP Address has changed from what DNS is reporting
	if [ $CURRENT_WAN_IP != $DNS_IP ]; then
		echo "$CURRENT_TIME: DNS IP not up to date, currently: $DNS_IP, but our IP is $CURRENT_WAN_IP" >> $LOG_FILE
		$DDNS_UPDATE_COMMAND
		echo "$CURRENT_TIME: Updated DynDNS Service, server sent response:" >> $LOG_FILE
                echo -e "\n" >> $LOG_FILE
                cat $CURL_LOG_FILE >> $LOG_FILE
                echo -e "\n" >> $LOG_FILE
                rm $CURL_LOG_FILE
	fi
done
