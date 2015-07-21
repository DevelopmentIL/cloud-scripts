#!/bin/bash

email=$1

echo "Set root email: $email"

grep -q "root: ${email}" /etc/aliases

# if not then create it
if [ $? -ne 0 ]; then
	echo "root: ${email}" >> /etc/aliases
else
	echo 'Email found. No changes made.'
fi

grep "root" /etc/aliases