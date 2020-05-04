#!/bin/bash -ex

# startup script for Ubuntu instances
# to update list of available packages and their versions then upgrade installed packages to those versions
# also install and run a simple web service for testing purposes only

# base applications such as Docker CE and Python 3 should be baked into the Packer template
# additional configuration to be done by Ansible to automate tasks specific to a nodes intended purpose

echo "Installing PHP and Apache2"
sleep 30
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install -y php libapache2-mod-php
sudo echo "Hello World" > index.html
nohup busybox httpd -f -p 8080 &