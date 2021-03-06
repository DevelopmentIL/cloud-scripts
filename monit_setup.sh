#!/bin/bash

apt-get -y install monit

hostname=`hostname`

echo "

check system $hostname
	if loadavg (1min) > 4 then alert
	if loadavg (5min) > 2 then alert
	if memory usage > 75% then alert
	if swap usage > 25% then alert
	if cpu usage (user) > 70% then alert
	if cpu usage (system) > 30% then alert
	if cpu usage (wait) > 20% then alert
" >> /etc/monit/monitrc

monit reload
update-rc.d monit defaults