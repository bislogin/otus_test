#!/bin/bash

REMOTE_SSH_USER="bazhenov"
REMOTE_SSH_HOST="172.20.1.40"

DB_USER="root"
DB_NAME="otus"

LOCAL_BACKUP_PATH="/home/bazhenov/backup/mysql/test_tbl.sql.gz"

# 1. Создаем базу, если её нет (через SSH)
ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "mysql -u ${DB_USER} -e 'CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;'"

if [ $? -eq 0 ]; then
    echo "Databases '$DB_NAME' готова (проверена/создана)."
else
    echo "Ошибка при создании базы данных."
    exit 1
fi

# 2. Распаковываем локальный архив и отправляем поток в MySQL на удаленный сервер
echo "Загрузка данных в базу..."
gunzip < "$LOCAL_BACKUP_PATH" | ssh ${REMOTE_SSH_USER}@${REMOTE_SSH_HOST} "mysql -u ${DB_USER} -p'${DB_PASS}' ${DB_NAME}"

if [ $? -eq 0 ]; then
    echo "Восстановление успешно завершено!"
else
    echo "Произошла ошибка при импорте данных."
    exit 1
fi
