# mongo-backup
A small script to make daily backups of a MongoDB database, and moves them to Google Cloud Storage.

This version is intende to be run on the DB server(s) themselves, scheduled by a cron job. The script on the primnary will exit. This script is specific to my needs, so it assumes a 2 node replicaset. If you wanted to run this on N+2> replicaset, you'll need better handling of primary/secondary detection
