#!/bin/bash

REMOTE_SSH_USER="bazhenov"
REMOTE_SSH_HOST="172.20.1.40"

DB_USER="repl"
DB_PASS="password#2026"
DB_NAME="otus"

BACKUP_DIR="/home/bazhenov/backup/mysql/backup"

LOCAL_BACKUP_PATH=$(find "$BACKUP_ROOT" -type f -name "*.sql.gz" -printf "%T@ %p\n" 2>/dev/null | sort -rn | head -n 1 | cut -d' ' -f2-)

if [ -z "$LATEST_BACKUP" ] || [ ! -f "$LATEST_BACKUP" ]; then
    exit 1
fi

ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "mysql -u ${DB_USER} -p'${DB_PASS}' -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4;'"

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
