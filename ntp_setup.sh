#!/bin/bash

localtime=$1

while [ 1 ]
do
	echo "Setup time zone to $localtime"
	
	if [ -f $localtime ]; then
		break
	fi
	
	echo "file not found!"
done

apt-get -y install ntp
ln -sf $localtime /etc/localtime
service ntp start
update-rc.d ntp defaults

date
	
	
	

