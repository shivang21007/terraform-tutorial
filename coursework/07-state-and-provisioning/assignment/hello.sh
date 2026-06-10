#!/usr/bin/env bash

sudo apt-get update -y 
sudo apt install nginx -y
sudo systemctl start nginx 
