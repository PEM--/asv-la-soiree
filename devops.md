## Devops on OSX with Docker set for Ubuntu 15.04
### Installing the tooling
If you have never done it before install Homebrew and its plugin Caskroom.
```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask
```

Then install VirtualBox and Vagrant:
```sh
brew cask install virtualbox vagrant
```

Now install Docker and its tools:
```sh
brew install docker docker-machine docker-compose
```

### Create your Docker machines
#### Initializing the VM with Vagrant
Create a `Vagrantfile` that matches your production environment.
Here, we are using an Ubuntu 15.04 with Docker pre-installed.
```
hosts = {
  "dev" => "192.168.33.10",
  "preprod" => "192.168.33.11"
}

$provisioningScript = <<SCRIPT
# Overriding bad Systemd default in Docker startup script
sudo mkdir -p /etc/systemd/system/docker.service.d
echo -e '[Service]\n# workaround to include default options\nEnvironmentFile=-/etc/default/docker\nExecStart=\nExecStart=/usr/bin/docker -d -H fd:// $DOCKER_OPTS' | sudo tee /etc/systemd/system/docker.service.d/ubuntu.conf
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --storage-driver aufs --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic"'  | sudo tee /etc/default/docker
sudo systemctl daemon-reload
sudo systemctl restart docker
# Enable Docker on server reboot
sudo systemctl enable docker
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
```

Now, we are starting our virtual server and declare it as a Docker Machine:
```sh
vagrant up --no-provision
```

Open 3 terminal sessions. In the first session, launch the following commands:
```sh
docker-machine -D create -d generic \
  --generic-ip-address 192.168.33.10 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  dev
```

In the second session, launch the following commands:
```sh
docker-machine -D create -d generic \
  --generic-ip-address 192.168.33.11 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  preprod
```

Now, in the last session, wait for the 2 previous session to be blocked
on the following repeated message
`Daemon not responding yet: dial tcp 192.168.33.10:2376: connection refused`
and issue the following command:
```sh
vagrant provision preprod
```


### Links
* [Homebrew](http://brew.sh/)
* [Caskroom](https://github.com/caskroom/homebrew-cask)
* [Docker documentation](https://docs.docker.com/)
* [Secure Docker](https://docs.docker.com/articles/https/)
* [OpenSSL Howto](https://www.madboa.com/geek/openssl/)
* [Control and configure Docker with Systemd](https://docs.docker.com/articles/systemd/)
* [How to configure Docker on Ubuntu 15.04 (workaround)](http://nknu.net/how-to-configure-docker-on-ubuntu-15-04/)
