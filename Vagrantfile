hosts = {
  "dev" => "192.168.33.10"
}

# hosts = {
#   "dev" => "192.168.33.10",
#   "preprod" => "192.168.33.11"
# }


# $provisioningScript = <<SCRIPT
# sudo apt-get update
# sudo apt-get -y upgrade
# sudo apt-get install -y curl
# curl -sSL https://get.docker.com/ | sh
# sudo usermod -aG docker vagrant
# sudo apt-get autoremove -y
# sudo systemctl enable docker
# sudo service docker start
# SCRIPT

$provisioningScript = <<SCRIPT
echo Provisioning done
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.ssh.insert_key = false
  hosts.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.hostname = "%s.example.org" % name
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |v|
        v.name = name
      end
      vm.vm.provision "shell", inline: $provisioningScript
    end
  end
end
