#!/bin/bash
DESTINATION=$1

# ---> Updating, upgrating and installing the base
sudo apt update
sudo apt install curl -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update && sudo apt upgrade -y
sudo apt install docker-ce  -y

sudo docker --version

sudo usermod -aG docker ubuntu

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker–compose --version
 
# clone Odoo directory
git clone --depth=1 https://fjvigil89:89120815065AlmaElena@github.com/fjvigil89/odoo12.git $DESTINATION
# set permission
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION
# run Odoo
sudo docker-compose -f $DESTINATION/docker-compose.yml up -d
