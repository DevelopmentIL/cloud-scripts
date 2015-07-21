#!/bin/bash

cronfile=/etc/cron.daily/mongod

mkdir -p /backup/mongodb

echo '#!/bin/bash

BACKUPDIR="/backup/mongodb"
DOW=`date +%A` # Day of the week e.g. Monday

rm -rf "$BACKUPDIR/latest"
mkdir -p "$BACKUPDIR/latest"
mongodump --out "$BACKUPDIR/latest/"
find "$BACKUPDIR/latest/" -maxdepth 1 -mindepth 1 -type d -exec tar -zcvf {}.tar.gz {}  \;
find "$BACKUPDIR/latest/" -maxdepth 1 -mindepth 1 -type d -exec rm -rf {}  \;

rm -rf "$BACKUPDIR/$DOW.tar.gz"
tar -zcvf "$BACKUPDIR/$DOW.tar.gz" "$BACKUPDIR/latest"
' > $cronfile
	
chmod +x $cronfile