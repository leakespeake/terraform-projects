#!/bin/bash -ex

# startup script for Ubuntu instances - loaded by the template_file datasource for variable interpolation (DRY)
# to update list of available packages and their versions then upgrade installed packages to those versions
# also install and run a simple web service for testing purposes only

# base applications such as Docker CE and Python 3 should be baked into the Packer template for immediate Docker container & Ansible functionality
# additional configuration to be done by Ansible to automate tasks specific for a nodes intended purpose
# script location once deployed in EC2; /var/lib/cloud/instances/i-{instance-id}/user-data.txt

# debugging options; sudo tail -f /home/ubuntu/log.out - or - sudo cat /home/ubuntu/log.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/ubuntu/log.out 2>&1    # redirect stdout to file /home/ubuntu/log.out then redirect stderr to stdout

sleep 10

echo "UPDATE AND UPGRADE"
sudo apt-get update && sudo apt-get -y upgrade

echo "INSTALL NETWORK TOOLS"
sudo apt-get install -y net-tools

# Uncomplicated FireWall (UFW) to control iptables - /etc/ufw/ufw.conf - sudo ufw status numbered
echo "ADD ACLs TO UFW THEN ENABLE IT"
sudo ufw allow from 92.238.177.233/32 to any port ${access_port}
sudo ufw allow from 92.238.177.233/32 to any port ${docker_api_port}
sudo ufw allow ${service_port1}/tcp

sudo sed -i 's/no/yes/' /etc/ufw/ufw.conf

# ensure the Docker daemon is available via any network interface on port 2376 (but restricted to my source public IP via UFW and the EC2 Security Group)
echo "ENABLE REMOTE DOCKER API"
sudo mkdir /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/override.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker.service

echo "INSTALL WEB APPS"
sudo apt-get install -y php libapache2-mod-php
sudo sed -i "s/80/${service_port1}/" /etc/apache2/ports.conf
sudo systemctl restart apache2

sleep 10

sudo reboot