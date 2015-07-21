#!/bin/bash

config=/etc/nginx/sites-available/default
hostname=`hostname`

apt-get -y install nginx

echo "
map_hash_bucket_size 128;

map \$host \$backend_servers {
	hostnames;
	default 127.0.0.1:8080;

	$hostname 127.0.0.1:8080;
	www.$hostname 127.0.0.1:8080;
}

server {
	listen 80;

	server_name $hostname;

	location / {
		proxy_pass http://\$backend_servers;
		proxy_redirect off;
		
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-NginX-Proxy true;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_cache_bypass \$http_upgrade;
		
		client_max_body_size 16m;
		client_body_buffer_size 128k;
		proxy_buffering on;
		proxy_connect_timeout 90;
		proxy_send_timeout 90;
		proxy_read_timeout 120;
		proxy_buffer_size 16k;
		proxy_buffers 32 32k;
		proxy_busy_buffers_size 64k;
		proxy_temp_file_write_size 64k;
	}
}

#server {
#	listen 443;
#	server_name $hostname www.$hostname;
#
#	ssl on;
#	ssl_certificate        /home/username/node/app/cert/server.crt;
#	ssl_certificate_key    /home/username/node/app/cert/server.key;
#	ssl_client_certificate /home/username/node/app/cert/ca.crt;
#
#	ssl_session_timeout 5m;
#
#	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
#	ssl_prefer_server_ciphers on;
#	ssl_ciphers \"AES256+EECDH:AES256+EDH:!aNULL\";
#	
#	location / {
#		proxy_pass https://127.0.0.1:8081;
#		proxy_redirect off;
#		
#		proxy_http_version 1.1;
#		proxy_set_header Upgrade \$http_upgrade;
#		proxy_set_header Connection 'upgrade';
#		proxy_set_header Host \$host;
#		proxy_set_header X-Real-IP \$remote_addr;
#		proxy_set_header X-NginX-Proxy true;
#		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#		proxy_cache_bypass \$http_upgrade;
#		
#		client_max_body_size 16m;
#		client_body_buffer_size 128k;
#		proxy_buffering on;
#		proxy_connect_timeout 90;
#		proxy_send_timeout 90;
#		proxy_read_timeout 120;
#		proxy_buffer_size 16k;
#		proxy_buffers 32 32k;
#		proxy_busy_buffers_size 64k;
#		proxy_temp_file_write_size 64k;
#	}
#}

" > $config

nano $config

service nginx start
service nginx reload
update-rc.d nginx defaults

mkdir -p /etc/monit/conf.d
echo "check process nginx with pidfile \"/var/run/nginx.pid\"
	start program = \"/etc/init.d/nginx start\"
	stop program = \"/etc/init.d/nginx stop\"
" > /etc/monit/conf.d/nginx