#!/bin/bash

config=/etc/mongodb.conf

# add mongodb-org package
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
apt-get -y update
apt-get -y install mongodb-org

# sed -i "/^auth\s*=/c\auth = true" $config
# sed -i "/^#auth\s*=/c\auth = true" $config

grep -q "slowms" $config
 
# if not then create it
if [ $? -ne 0 ]; then
	echo "slowms = 500" >> $config
else
	sed -i "/^slowms\s*=/c\slowms = 500" $config
	sed -i "/^#slowms\s*=/c\slowms = 500" $config
fi

service mongod restart
update-rc.d mongod defaults

mkdir -p /etc/monit/conf.d
echo "check process mongodb with pidfile \"/run/mongodb.pid\"
	start program = \"/etc/init.d/mongod start\"
	stop program = \"/etc/init.d/mongod stop\"
" > /etc/monit/conf.d/mongod