#!/bin/bash

# make sure ufw installed
apt-get -y install ufw

# deny all by default
ufw default deny incoming
ufw default allow outgoing

# allow specific ports
ufw allow $1
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 53

# enbale firewall
ufw enable