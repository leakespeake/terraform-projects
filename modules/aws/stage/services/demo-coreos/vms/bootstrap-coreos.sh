#!/bin/bash -ex

# startup script for CoreOS instances - loaded by the template_file datasource
# to update list of available packages and their versions then upgrade installed packages to those versions
# services intended to be run solely via Docker containers for this OS

# base applications such as Docker CE and Python 3 should be baked into the Packer template for immediate Docker container & Ansible functionality
# additional configuration to be done by Ansible to automate tasks specific for a nodes intended purpose
# script location once deployed in EC2; /var/lib/cloud/instances/i-{instance-id}/user-data.txt

# debugging options; sudo tail -f /home/core/log.out - or - sudo cat /home/core/log.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/core/log.out 2>&1      # redirect stdout to file /home/core/log.out then redirect stderr to stdout

# do an update on the STABLE channel
sudo update_engine_client -check_for_update

#sudo reboot