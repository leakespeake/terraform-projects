#!/bin/bash -ex

# startup script for CentOS instances - loaded by the template_file datasource for variable interpolation (DRY)
# updates all currently installed packages (update) and removes all obsolete ones (upgrade)
# also installs and runs a simple web service for testing purposes only

# base applications such as Docker CE and Python 3 should be baked into the Packer template for immediate Docker container & Ansible functionality
# additional configuration to be done by Ansible to automate tasks specific for a nodes intended purpose
# script location once deployed in EC2; /var/lib/cloud/instances/i-{instance-id}/user-data.txt

# debugging options; sudo tail -f /home/centos/log.out - or - sudo cat /home/centos/log.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/centos/log.out 2>&1    # redirect stdout to file /home/centos/log.out then redirect stderr to stdout

sleep 20

sudo yum update -y && yum upgrade -y

sudo yum -y install firewalld
sudo firewall-offline-cmd --add-port=${access_port}/tcp
sudo firewall-offline-cmd --add-port=${docker_api_port}/tcp
sudo firewall-offline-cmd --add-port=${service_port1}/tcp
sudo systemctl enable firewalld
sudo systemctl start firewalld

sleep 10

sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# add the service port to selinux to allow this port to bind to httpd 
# only required if not default httpd port (80, 81, 443, 488, 8008, 8009, 8443, 9000)
sudo semanage port -m -t http_port_t -p tcp ${service_port1}

# use sed to replace the default port 80 value for Apache
# ensure use of double quotes for the shell to interpret the variable
sudo sed -i "s/80/${service_port1}/" /etc/httpd/conf/httpd.conf
sudo systemctl restart httpd