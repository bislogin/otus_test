#!/bin/bash


BACKUP_DIR="/home/bazhenov/mysql/backup/$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

DATABASES=$(mysql -uroot -e "SHOW DATABASES;" | grep -v Database | grep -v information_schema | grep -v mysql | grep -v performance_schema | grep -v sys)


for DB in "$DATABASES"; do
        DB_DIR="$BACKUP_DIR/$DB"
        mkdir -p "$DB_DIR"

        TABLES=$(mysql -uroot -D $DB -e "SHOW TABLES;" | grep -v "Tables_in_")

        for TABLE in $TABLES; do

                mysqldump --set-gtid-purged=OFF --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers -uroot  "$DB" "$TABLE" | gzip -1 > "$DB_DIR/$TABLE.sql.gz"

        done
done

scp -r /home/bazhenov/mysql/backup/ bazhenov@172.20.1.100:/tmp/mysql/backup/
