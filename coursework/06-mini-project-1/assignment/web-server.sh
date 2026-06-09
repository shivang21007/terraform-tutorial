#!/bin/bash
if command -v yum &> /dev/null; then
    yum update -y
    yum install nginx -y && sudo amazon-linux-extras install nginx1 -y
    systemctl start nginx
    systemctl enable nginx
elif command -v apt-get &> /dev/null; then
    apt-get update -y
    apt-get install nginx -y
    systemctl start nginx
    systemctl enable nginx
fi
