#!/bin/sh
if [ "$#" -ne 1 ]
then
    echo "Usage: letsencrypt-renew.sh (site)"
    echo " where site is something like 3diax.com"
    exit 1
fi

/usr/sbin/certbot-auto --config /etc/letsencrypt/configs/$1.conf --force-renew certonly

if [ $? -ne 0 ]
 then
        ERRORLOG=`tail /var/log/letsencrypt/letsencrypt.log`
        echo -e "The Let's Encrypt cert has not been renewed! \n \n" \
                 $ERRORLOG
 else
        nginx -s reload
fi

exit 0
