#!/bin/bash

# Best practice for scripts: avoid interactive prompts during upgrades/installs
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx net-tools htop curl -y

# Assuming the default nginx file might be index.nginx-debian.html on Ubuntu
# We use "|" as the sed delimiter to avoid escaping HTML slashes
sudo sed -i "s|.*<h1>.*|<h1>Welcome to SkyNet E-Commerce! $(hostname)</h1>|" /var/www/html/index.html
# If the file above doesn't exist (e.g. on Ubuntu), try the debian specific one:
sudo sed -i "s|.*<h1>.*|<h1>Welcome to SkyNet E-Commerce $(hostname)</h1>|" /var/www/html/index.nginx-debian.html

sudo systemctl restart nginx
sudo systemctl enable nginx