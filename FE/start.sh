#!/bin/bash

sudo apt update && sudo apt install nginx git -y 

mkdir /home/bazhenov/git
cd /home/bazhenov/git/
git init
git config --global user.name bazhenov
git config --global user.email bazhenilya@gmail.com
git branch -M main
git remote add origin git@github.com:bislogin/otus_test.git
git pull origin main

cd FE/
bash setup.sh
