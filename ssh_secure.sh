#!/bin/bash

config=/etc/ssh/sshd_config
sshPort=$1
 
# does the swap file already exist?
echo "Change ssh port to $sshPort"

sed -i "/Port/c\Port ${sshPort}" $config
sed -i "/PasswordAuthentication/c\PasswordAuthentication no" $config

grep -q "UseDNS" $config
 
# if not then create it
if [ $? -ne 0 ]; then
	echo "UseDNS no" >> $config
else
	sed -i "/UseDNS/c\UseDNS no" $config
fi

echo "check process sshd with pidfile /var/run/sshd.pid
	start program \"/etc/init.d/ssh start\"
	stop program \"/etc/init.d/ssh stop\"
" > /etc/monit/conf.d/ssh

service ssh restart

echo "ssh port has been changed!"
echo "Please verify that you can login... (keep this session open)"