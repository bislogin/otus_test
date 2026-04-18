#!/bin/bash

REMOTE_SSH_USER="bazhenov"
REMOTE_SSH_HOST="172.20.1.40"

DB_USER="root"
#DB_PASS="password#2026"
DB_NAME="otus"

BACKUP_DIR="/home/bazhenov/backup/mysql/backup"

echo "1. backup search..."
LOCAL_BACKUP_PATH=$(find "$BACKUP_DIR" -type f -name "*.sql.gz" -exec ls -t {} + | head -n 1)

if [ -z "$LOCAL_BACKUP_PATH" ]; then
    echo "ERROR: File not found. Check the path: ls -l $BACKUP_ROOT"
    exit 1
fi
echo "found: $LOCAL_BACKUP_PATH"



echo "2. creating a database '$DB_NAME'..."
ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "sudo mysql -u ${DB_USER} -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4;'"

if [ $? -eq 0 ]; then
    echo "Databases '$DB_NAME' created."
else
    echo "Error created, database exists"
    exit 1
fi

echo "3. Starting to import..."
gunzip < "$LOCAL_BACKUP_PATH" | ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "sudo mysql -u ${DB_USER} ${DB_NAME}"

if [ $? -eq 0 ]; then
    echo "Successful recovery!"
else
    echo "Error recovery."
    exit 1
fi
