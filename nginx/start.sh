#!/bin/bash

sudo apt update && sudo apt install nginx git -y 

mkdir /home/bazhenov/git
cd /home/bazhenov/git/
git init
git config --global user.name bazhenov
git config --global user.email bazhenilya@gmail.com
