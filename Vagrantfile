hosts = {
  "dev" => "192.168.33.10",
  "preprod" => "192.168.33.11"
}

Vagrant.configure(2) do |config|
  config.vm.box = "boxcutter/ubuntu1504-docker"
  config.ssh.insert_key = false
  hosts.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.hostname = "%s.example.org" % name
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |v|
        v.name = name
      end
    end
  end
end
