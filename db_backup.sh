#!/bin/bash
# Path to boto config file, needed by gsutils
BOTO_CONFIG="/etc/boto.cfg"

# Path in which to create the backup (will get cleaned later)
BACKUP_PATH="/backup/"

# DB name
DB_NAME="MYDB"

# Google Cloud Storage Bucket Name - needs to exist
BUCKET_NAME="mybucket/backup/db"

# Don't run on the master of a replica set, only on replicas
IS_MASTER=`mongo --quiet --eval "d=db.isMaster(); print( d['ismaster'] );"`
if [ "$IS_MASTER" == "true" ]
then
 echo "Master, so not running - exiting..."
 exit 2
fi

CURRENT_DATE=`date +"%d"`

# Backup filename
BACKUP_FILENAME="$DB_NAME$CURRENT_DATE.tar.gz"

# Create the backup
mongodump --db ${DB_NAME} -o ${BACKUP_PATH}

# Archive and compress
cd ${BACKUP_PATH}
tar -cvzf ${BACKUP_PATH}${BACKUP_FILENAME} *

# Copy to Google Cloud Storage
echo "Copying $BACKUP_PATH$BACKUP_FILENAME to gs://$BUCKET_NAME/"
gsutil cp ${BACKUP_PATH}${BACKUP_FILENAME} gs://${BUCKET_NAME}/ 2>&1
echo "Copying finished"
echo "Removing backup data ${BACKUP_PATH}*"
rm -rf ${BACKUP_PATH}*
