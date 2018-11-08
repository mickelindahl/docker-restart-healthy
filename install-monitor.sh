#!/bin/bash

if [ ! -f .config ];then

   echo "Missing .config"

fi

FILE_NAME=docker-restart-unhealthy-cron

if [ -f $FILE_NAME ];then

    # Clear if exists
    rm $FILE_NAME

fi

touch $FILE_NAME

TEMPLATE="{cron} root cd {src} && ./monitor.sh {container}"

while IFS='' read -r CONTAINER || [[ -n "$CONTAINER" ]]; do
    echo "Adding $CONTAINER"
    echo $TEMPLATE >> $FILE_NAME
    sed -i "s#{src}#$(pwd)#g" $FILE_NAME
    sed -i "s#{container}#$CONTAINER#g" $FILE_NAME
done < ".config"

sed -i "s#{cron}#* * * * *#g" $FILE_NAME


sudo mv $FILE_NAME "/etc/cron.d/$FILE_ENAME"

chmod +x monitor.sh

