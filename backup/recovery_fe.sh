#!/bin/bash

scp /home/bazhenov/log/filebeat_8.17.1_amd64-224190-6bb8de.deb root@172.20.1.10:/home/bazhenov/filebeat_8.17.1_amd64-224190-6bb8de.deb
scp /home/bazhenov/git/FE/recovery.sh root@172.20.1.10:/tmp && ssh root@172.20.1.10 "sudo bash /tmp/recovery.sh"

