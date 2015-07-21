#!/bin/bash
set -e
username=$1

echo "Node username: $username"
read -e -p "Please enter a node folder: " -i "node" folder

if [ ! -d "/home/$username" ]
then
	useradd -d /home/$username -m $username
	usermod -a -G sudo $username
fi

nodepath="/home/$username/$folder"

if [ ! -d "$nodepath" ]
then
	read -p "Do you want to clone a git repository? (Y/n) " -r

	if [[ ! $REPLY =~ ^[nN]$ ]]
	then
		read -p "Enter git url: " -i "https://" git
		
		su -l $username -c "cd ~/ && git clone $git $folder && cd ~/$folder"
	fi
fi

read -p "Do you want to rsync files from remote server? (y/N) " -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
	read -p "Do you want generate public SSH key? (y/N) " -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		ssh-keygen -f ~/.ssh/id_rsa -q -P ""
		cat ~/.ssh/id_rsa.pub
		echo ""
		echo "Please append the following key on the remote server"
		echo "ie. \`nano ~/.ssh/authorized_keys\`"
		echo "Press enter to continue..."
		read
	fi

	read -e -p "Enter remote user login: " -i "root" remoteUser
	read -p "Enter remote server ip: " remoteIp
	read -e -p "Enter remote server port: " -i "22" remotePort
	read -e -p "Enter remote path: " -i "$nodepath/" remotePath
	
	if [ ! -d "$nodepath" ]
	then
		mkdir $nodepath
	fi
	
	rsync -vaz -e "ssh -p $remotePort" $remoteUser@$remoteIp:$remotePath $nodepath/
	rm -rf $nodepath/node_modules/*
	chown -R $username:$username $nodepath
else
	if [ ! -d "$nodepath" ]
	then
		echo "Please create node files under: $nodepath"
		exit
	fi
	
	remoteUser=root
	remotePort=22
fi

read -p "Do you want restore database from remote server? (y/N) " -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	read -e -p "Enter remote user login: " -i "$remoteUser" remoteUser
	read -e -p "Enter remote server ip: " -i "$remoteIp" remoteIp
	read -e -p "Enter remote server port: " -i "$remotePort" remotePort
	
	read -e -p "Enter db username: " -i $username dbUser
	read -p "Enter db pasword: " dbPassword
	read -e -p "Enter db name: " -i $username dbName
	
	mongodump="mongodump -u $dbUser -p $dbPassword --db $dbName"
	
	echo "dump database..."
	ssh -p $remotePort $remoteUser@$remoteIp "cd /tmp && $mongodump && tar -cf dump.tar dump && rm -rf dump"
	scp -P $remotePort $remoteUser@$remoteIp:/tmp/dump.tar /tmp/dump.tar
	ssh -p $remotePort $remoteUser@$remoteIp "cd /tmp && rm -f dump.tar"
	
	echo "extract database..."
	rm -rf /tmp/dump
	tar -xf /tmp/dump.tar -C /tmp
	rm -f /tmp/dump.tar
	
	echo "restore database..."
	mongorestore --noIndexRestore /tmp/dump
	rm -rf /tmp/dump
fi

read -p "Do you want to \`npm install\`? (Y/n) " -r
if [[ ! $REPLY =~ ^[nN]$ ]]
then
	su -l $username -c "cd ~/$folder && npm install"
fi

read -p "Add startup script? (Y/n) " -r
if [[ ! $REPLY =~ ^[nN]$ ]]
then
	read -e -p "Enter script: " -i "cd ~/$folder; sh ./run.sh" initScript
	sed -i -e "\$i \su -l $username -c \"$initScript\"\n" /etc/rc.local
fi

echo "Done! Please configure node instance."
echo "Type 'exit' when you done."
echo ""
su $username