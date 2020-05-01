#!/bin/bash
echo "Installing PHP and Apache2"
sleep 30
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install -y php libapache2-mod-php
sudo echo "Hello World" > index.html
sudo nohup busybox httpd -f -p 8080 &