#!/bin/bash

CONTAINER=$1

HEALTH=$(docker inspect --format "{{.State.Health.Status }}" $CONTAINER)

if [ $HEALTH = "unhealthy" ]; then

  echo "$CONTAINER is not healthy restarting"

  STATE=$(docker inspect --format='{{.State}}' $CONTAINER)

  if [ ! -f monitor.log ]; then
     touch monitor.log
  fi

  DATE=`date '+%Y-%m-%d %H:%M:%S'`

  echo "$DATE | $CONTAINER | unhealthy" >> monitor.log

  docker stop $CONTAINER
  docker start $CONTAINER

else

  echo "$CONTAINER is up and running $STATUS"

fi
