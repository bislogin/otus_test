#!/bin/bash

REMOTE_SSH_USER="bazhenov"
REMOTE_SSH_HOST="172.20.1.40"

DB_USER="repl"
DB_PASS="password#2026"
DB_NAME="otus"

BACKUP_DIR="/home/bazhenov/backup/mysql/backup/"

LOCAL_BACKUP_PATH=$(find "$BACKUP_ROOT" -name "*.sql.gz" -printf "%T@ %p\n" | sort -rn | head -n 1 | cut -d' ' -f2-)

ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "mysql -u ${DB_USER} -p'${DB_PASS}' -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME};'"

if [ $? -eq 0 ]; then
    echo "Databases '$DB_NAME' created."
else
    echo "Error created, database exists"
    exit 1
fi

gunzip < "$LOCAL_BACKUP_PATH" | ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "mysql -u ${DB_USER} -p'${DB_PASS}' ${DB_NAME}"

if [ $? -eq 0 ]; then
    echo "Successful recovery!"
else
    echo "Error recovery."
    exit 1
fi
