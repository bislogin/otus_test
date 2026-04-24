#!/bin/bash

scp /home/bazhenov/git/FE/recovery.sh root@172.20.1.10:/tmp && ssh root@172.20.1.10 "sudo bash /tmp/recovery.sh"

