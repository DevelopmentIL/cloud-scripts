#!/bin/bash

swapsize=$1
 
# does the swap file already exist?
grep -q "swapfile" /etc/fstab
 
# if not then create it
if [ $? -ne 0 ]; then
	echo "Create swapfile of $swapsize megabytes"

	fallocate -l ${swapsize}M /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
	echo 'swapfile found. No changes made.'
fi
 
# output results to terminal
cat /proc/swaps
cat /proc/meminfo | grep Swap