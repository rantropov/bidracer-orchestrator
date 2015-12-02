$script = <<SCRIPT
#set -e
#set -x
mkdir $HOME/rtbkit-orchestration-logs
sh /vagrant/orchestrator-bootstrap/orchestrator_bootstrap.sh 2>&1 | tee $HOME/rtbkit-orchestration-logs/orchestrator_bootstrap.log
exit
SCRIPT

Vagrant.configure(2) do |config|
  config.ssh.private_key_path = "./.ssh/rackspace_rsa"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [".git/"]
  config.vm.provider :rackspace do |rs|
    rs.username = ENV['RACKSPACE_USERNAME']
    rs.api_key  = ENV['RACKSPACE_API_KEY']
    rs.admin_password = ENV['VM_ROOT_PASSWORD']
    rs.flavor   = /2 GB Performance/
    rs.image    = /Ubuntu 12.04/
    rs.rackspace_region = :dfw
    rs.server_name =  "bidracer-orchestrator"
    rs.public_key_path  = "./.ssh/rackspace_rsa.pub"
  end
  config.vm.provision :shell, :inline => $script
end
