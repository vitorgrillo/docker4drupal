
CHMOD="$(which chmod)"
GZIP="$(which gzip)"

DEST="/"
MBD="$DEST"
HOST="localhost"
NOW="$(date +"%Y%m%d-%H%M")"
FILE=""
DBS=""
IGGY=""
EMAILMESSAGE="/tmp/emailmessage.txt"
echo "Backup OK dos bancos de dados com os seguintes arquivos:"> $EMAILMESSAGE
DBS="$($MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases')"

rm /mnt/backups/mysql/*gz

for db in $DBS
do
  skipdb=-1
        if [ "$IGGY" != "" ];
        then
                for i in $IGGY
                do
                        [ "$db" == "$i" ] && skipdb=1 || :
                done
        fi
        if [ "$skipdb" == "-1" ] ; then
                $MYSQLCHECK -o -s -u $MyUSER -h $MyHOST -p$MyPASS $db
                FILE="$MBD/$db.$NOW.sql.gz"
                $MYSQLDUMP -c -e -u $MyUSER -h $MyHOST -p$MyPASS $db | $GZIP -9 > $FILE
                echo $FILE >>$EMAILMESSAGE
        fi
done

tar czf /var/www/vhosts/backup/bd/fulldatabase.$NOW.tar.gz $DEST/*

SUBJECT="Backup de banco de dados"
# Email To ?
EMAIL="nono@nono.com"
# Email text/message
echo "" >> $EMAILMESSAGE
echo "O backup esta disponivel em http://myserver.com/bd/fulldatabase.$NOW.tar.gz" >>$EMAILMESSAGE
# send an email using /bin/mail
/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE