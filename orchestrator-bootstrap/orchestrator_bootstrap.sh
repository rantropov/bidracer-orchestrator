#!/bin/bash
###################################################################
# This script will do the following tasks on Ubuntu 12.04
# 1. Update the system packages source list
# 2. Upgrade the system packages with latest ones
# 3. Installs Vagrant
# 4. Installs Ansible
# 5. setsup Vagrantfile to spin up rtbkit-master and provision it
# 5. create a tmux session and execute Vagrant up in the session
# 6. Detach the session
###################################################################
echo "\n####################################################################"
echo "+++++++++++++++++ Bootstrapping ansible controller +++++++++++++++++"
echo "####################################################################\n"
###################################################################
#set -o verbose
export DEBIAN_FRONTEND=noninteractive
####################################################################
echo "Updating ubuntu package repository sources"
apt-get --assume-yes update > /dev/null
####################################################################
# Install tmux
####################################################################
echo "\nInstalling tmux"
apt-get --assume-yes install tmux > /dev/null
####################################################################
# Set up the directories and copy files from /vagrant to home folder
####################################################################
logs="$HOME/rtbkit-orchestration-logs"
cp -r /vagrant $HOME/bid-racer
cd $HOME/bid-racer
###################################################################
chmod +x ./orchestrator-bootstrap/install_vagrant_script.sh
sh orchestrator-bootstrap/install_vagrant_script.sh 2>&1 | tee $logs/install_vagrant_script.log
###################################################################
chmod +x ./orchestrator-bootstrap/install_ansible_script.sh
sh orchestrator-bootstrap/install_ansible_script.sh 2>&1 | tee $logs/install_ansible_script.log
###################################################################
# Install git
###################################################################
apt-get --assume-yes install git-core > /dev/null
###################################################################
# Start Vagrant up for bidracer-core
###################################################################
cd $HOME
git clone --depth=1 --branch=master https://github.com/bidracer/bidracer-core.git
cd bidracer-core
###################################################################
echo "\nSetting up Vagrantfile, SSH Keys and .env file to build RTBKit machine"
rm -rf Vagrantfile
cp ./ac-bootstrap/Vagrantfile_rtbkit ./Vagrantfile
cp -r $HOME/bid-racer/.ssh ./.ssh
cp $HOME/bid-racer/.env ./.env
sleep 4
###################################################################
echo "\nStarting vagrant up in tmux session : bc"
tmux new-session -d -s bc
tmux send-keys -t bc  'vagrant up 2>&1 | tee $logs/vagrantup_bidracer_core_log.log'
tmux send-keys -t bc  Enter
sleep 4
echo "\nDetaching from tmux session : bc"
tmux detach -s bc
sleep 4
###################################################################
# Start Vagrant up for bidracer-adserver
###################################################################
cd $HOME
git clone --depth=1 --branch=master https://github.com/bidracer/bidracer-adserver.git
cd bidracer-adserver
cp -r $HOME/bid-racer/.ssh ./.ssh
cp $HOME/bid-racer/.env ./.env
###################################################################
echo "\nStarting vagrant up in tmux session : bas"
tmux new-session -d -s bas
tmux send-keys -t bas  'vagrant up 2>&1 | tee $logs/vagrantup_bidracer_adserver_log.log'
tmux send-keys -t bas  Enter
sleep 4
echo "\nDetaching from tmux session : bas"
tmux detach -s bas
sleep 4
###################################################################
# Start Vagrant up for bidracer-ui
###################################################################
cd $HOME
git clone --depth=1 --branch=master https://github.com/bidracer/bidracer-ui.git
cd bidracer-ui
cp -r $HOME/bid-racer/.ssh ./.ssh
cp $HOME/bid-racer/.env ./.env
###################################################################
echo "\nStarting vagrant up in tmux session : bui"
tmux new-session -d -s bui
tmux send-keys -t bui  'vagrant up 2>&1 | tee $logs/vagrantup_bidracer_ui_log.log'
tmux send-keys -t bui  Enter
sleep 4
echo "\nDetaching from tmux session : bui"
tmux detach -s bui
sleep 4
###################################################################
#Display info to the user
###################################################################
echo "\nBidracer orchestration started now"
sleep 2
echo "\nIt might take upto 4 hours to build the system from source"
sleep 2
echo "\nIf you have chosen to use rtbkit binary package then your system will be ready in about 10 minutes"
sleep 2
ip_address="$(ip addr | grep 'eth0' | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
echo "\nIP of your orchestration machine: $ip_address"
sleep 2
echo "\nSSH into orchestration machine to see the status of the build using tmux"
sleep 2
echo "\nCommand to list tmux sessions is 'tmux list-sessions'"
sleep 2
echo "\nCommand to check bidracer-core status 'tmux attach -t bc'"
sleep 2
echo "\nCommand to check bidracer-adserver status 'tmux attach -t bas'"
sleep 2
echo "\nCommand to check bidracer-ui status 'tmux attach -t bui'"
sleep 2
echo "\n####################################################################"
echo "++++++++++++++++++++++++++++ Have fun ++++++++++++++++++++++++++++++"
echo "####################################################################"
