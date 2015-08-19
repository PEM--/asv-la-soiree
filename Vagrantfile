# hosts = {
#   "dev" => "192.168.33.10",
#   "preprod" => "192.168.33.11"
# }

hosts = {
  "dev" => "192.168.33.10"
}

$provisionningScript = <<SCRIPT
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y docker.io
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
      vm.vm.provision "shell", inline: $provisionningScript
    end
  end
end
