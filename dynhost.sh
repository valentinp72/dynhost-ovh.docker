#! /bin/sh
# Mainly inspired by DynHost script given by OVH
# New version by zwindler (zwindler.fr/wordpress)
#
# Initial version was doing  nasty grep/cut on local ppp0 interface
#
# This coulnd't work in a NATed environnement like on ISP boxes
# on private networks.
#
# Also got rid of ipcheck.py thanks to mafiaman42
#
# Code cleanup and switching from /bin/sh to /bin/bash to work around a bug in
# Debian Jessie ("if" clause not working as expected)
#
# This script uses curl to get the public IP, and then uses wget
# to update DynHost entry in OVH DNS
#
# Logfile: dynhost.log
#
# SET ENV VARIABLES: "DYNHOST_DOMAIN_NAME", "DYNHOST_LOGIN" and
# "DYNHOST_PASSWORD" to reflect YOUR account variables.

getip() {
	IP=`dig +short myip.opendns.com @resolver1.opendns.com`
	OLDIP=`dig +short ${DYNHOST_DOMAIN_NAME}`
}

######Main#####
    echo ----------------------------------
    echo `date`
    getip

    if [ "$IP" ]; then
        if [ "$OLDIP" != "$IP" ]; then
            echo "Old IP: [$OLDIP]"
            echo "New IP: [$IP]"
			curl "https://www.ovh.com/nic/update?system=dyndns&hostname=${DYNHOST_DOMAIN_NAME}&myip=${IP}" -u ${DYNHOST_LOGIN}:${DYNHOST_PASSWORD}
        else
            echo "Notice: IP ${DYNHOST_DOMAIN_NAME} [$OLDIP] is identical to WAN [$IP]! No update required."
        fi
    else
        echo "Error: WAN IP not found. Exiting!"
    fi
