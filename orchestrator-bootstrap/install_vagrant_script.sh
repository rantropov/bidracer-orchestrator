#!/bin/bash
##################################################################
# Author : Swarup Donepudi
##################################################################
# Arguments : None
##################################################################
# This script will do the following tasks on Ubuntu 12.04
# 1. Install dpkg
# 2. Install vagrant using dpkg
# 3. Install rackspace plugin
##################################################################
#set -o verbose
export DEBIAN_FRONTEND=noninteractive
echo "\nInstalling Vagrant on controller node"
###################################################################
# Install dpkg
###################################################################
cd $HOME
apt-get --assume-yes install dpkg-dev > /dev/null
wget --quiet https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
dpkg -i vagrant_1.7.4_x86_64.deb > /dev/null
vagrant plugin install vagrant-rackspace > /dev/null
vagrant plugin install vagrant-env > /dev/null
###################################################################
#Vagrant installation is complete
###################################################################
