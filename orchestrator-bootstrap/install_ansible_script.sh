#!/bin/bash
##################################################################
# Author : Swarup Donepudi
##################################################################
# Arguments : None
##################################################################
# This script will do the following tasks on Ubuntu 12.04
# 1. Download Ansible
# 2. Install Ansible
##################################################################
#set -o verbose
export DEBIAN_FRONTEND=noninteractive
echo "\nInstalling Ansible on controller node"
###################################################################
# Install Ansible
###################################################################
sudo apt-get install python-pip python-dev --assume-yes  > /dev/null
sudo pip install ansible > /dev/null
###################################################################
#Ansible installation is complete
###################################################################
