#!/bin/bash

CURRENT_DATE=`date +"%Y%m%d-%H%M"`
BACKUP_PATH="/home/vagrant/backups/$CURRENT_DATE"
export LC_ALL="en_US.UTF-8"

MONGOHOST=$(hostname)


# Don't run on the master of a replica set, only on replicas
IS_MASTER=`mongo $MONGOHOST:27017 --quiet --eval "d=db.isMaster(); print( d['ismaster'] );"`
if [ "$IS_MASTER" == "true" ]
then
    echo "is master so exit"
    exit 2
fi

CmdStatus=`mongodump --out $BACKUP_PATH --host $MONGOHOST`

if [ $? -ne 0 ]; then
  echo "There is an issue while trying to take dump in $MONGOHOST. Aborting dump process, please check!"
  exit 2
fi

echo "Backup completed"