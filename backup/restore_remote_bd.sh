#!/bin/bash

REMOTE_SSH_USER="bazhenov"
REMOTE_SSH_HOST="172.20.1.40"

DB_USER="root"
DB_NAME="otus"

LOCAL_BACKUP_PATH="/home/bazhenov/backup/mysql/test_tbl.sql.gz"

ssh -t ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "sudo mysql -u ${DB_USER} -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME};'"

if [ $? -eq 0 ]; then
    echo "Databases '$DB_NAME' created."
else
    echo "Error created, database exists"
    exit 1
fi

gunzip < "$LOCAL_BACKUP_PATH" | ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "sudo mysql -u ${DB_USER} ${DB_NAME}"

if [ $? -eq 0 ]; then
    echo "Successful recovery!"
else
    echo "Error recovery."
    exit 1
fi
