#!/bin/bash

scp /home/bazhenov/git/FE/recovery.sh bazhenov@172.20.1.10:/tmp && ssh bazhenov@172.20.1.10 "sudo bash /tmp/recovery.sh"

