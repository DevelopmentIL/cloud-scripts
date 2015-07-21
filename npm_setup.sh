#!/bin/bash

apt-get -y install nodejs npm

read -e -p "Please choose node version: " -i "stable" nversion
npm install -g n
n $nversion

npm install -g pm2
pm2 update
