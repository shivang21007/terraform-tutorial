#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install nginx net-tools htop curl -y
sudo systemctl restart nginx
sudo systemctl enable nginx



