# Проектная работа
## Автоматизация процедур аварийного восстановления (Disaster Recovery) для дежурного технического персонала

Аварийное восстановление сервера "с нуля"

Рабочая схема:

<img width="659" height="565" alt="изображение" src="https://github.com/user-attachments/assets/54b0fcbd-d689-4fcb-a8bf-8cba3a8ffc9c" />  

IP Адресация:  

|Server|IP addresses|Mask|Gateway|  
|-----|-----|-----|-----|  
|FE|172.20.1.10|255.255.255.0|172.20.1.1|  
|BE-1|172.20.1.20|255.255.255.0|172.20.1.1| 
|BE-2|172.20.1.30|255.255.255.0|172.20.1.1| 
|MySQL-master|172.20.1.40|255.255.255.0|172.20.1.1| 
|MySQL-slave|172.20.1.50|255.255.255.0|172.20.1.1| 
|Log|172.20.1.60|255.255.255.0|172.20.1.1| 
|Monitor|172.20.1.70|255.255.255.0|172.20.1.1| 
|Backup|172.20.1.100|255.255.255.0|172.20.1.1|   

План восстановления:  
1) При выходе сервера из стоя, на новом сервере настраиваем сетевые настройки в netplan согласно таблици с ip адресацией.
2) добавляем пользователя:
```
useradd -m -s /bin/bash username
passwd username
usermod -aG sudo username
```

3) Генерируем ssh ключ и добавляем его в git
```
ssh-keygen
cat ~/.ssh/id_rsa.pub
```
4) Устанавляваем git и скачиваем репозиторий:
```
sudo apt update && sudo apt install git -y 
mkdir /home/bazhenov/git
cd /home/bazhenov/git/
git init
git config --global user.name bazhenov
git config --global user.email bazhenilya@gmail.com
git branch -M main
git remote add origin git@github.com:bislogin/otus_test.git
git config pull.rebase false
git pull origin main
```
5) Заходим в нужную директорию, и запускаем `setup.sh`
