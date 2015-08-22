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

### Create your virtual machines as Docker Machine
Create a `Vagrantfile` that matches your production environment.
Here, we are using an Ubuntu 15.04 with Docker pre-installed.
```ruby
hosts = {
  "dev" => "192.168.33.10",
  "preprod" => "192.168.33.11"
}

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.ssh.insert_key = false
  hosts.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.hostname = "%s.example.org" % name
      #vm.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: ip
      vm.vm.network "private_network", ip: ip
      vm.vm.provider "virtualbox" do |v|
        v.name = name
      end
      vm.vm.provision "shell", path: "provisioning.sh"
    end
  end
end
```

> I've provided 2 network configuration here. The first one is a private network
  leading to 2 virtual machines that are not accessible to your local network (
  only your local OSX). The second bridges your local OSX network driver so that
  your container gains public access within your LAN. Note that for both of these
  network configurations, I've used static IPs.

Before creating our virtual machine, we need to setup a `provisioning.sh`:
```sh
#!/bin/bash
# Overriding bad Systemd default in Docker startup script
sudo mkdir -p /etc/systemd/system/docker.service.d
echo -e '[Service]\n# workaround to include default options\nEnvironmentFile=-/etc/default/docker\nExecStart=\nExecStart=/usr/bin/docker -d -H fd:// $DOCKER_OPTS' | sudo tee /etc/systemd/system/docker.service.d/ubuntu.conf
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --storage-driver aufs --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic"'  | sudo tee /etc/default/docker
sudo systemctl daemon-reload
sudo systemctl restart docker
# Enable Docker on server reboot
sudo systemctl enable docker
# Remove unused packages
sudo apt-get autoremove -y
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
vagrant provision
```

> **What's going on here?**: Actually, the current state of Docker for Ubuntu 15.04
  doesn't support `DOCKER_OPTS`. This is due to the transition in Ubuntu from
  **upstart** to **Systemd**. Plus, when we are creating our Docker Machine in
  our local OSX, Docker Machine re-install Docker on the host. Thus, we end up
  with a screwed installation on the host unable to speak to the outside world
  (leading to the message `Daemon not responding yet: dial tcp 192.168.33.10:2376: connection refused`).
  Basically, the vagrant provisioning script patches both vagrant virtual servers.
  You can reuse the content of this script on your production server when you
  create the associated Docker Machine. For this, you can use the following command:
  `ssh root@example.com "bash -s" < ./provisioning.sh`

In this last section, we will finish our configuration of our development and
pre-production VM by installing Docker Machine and securing their open ports
with simple firewall rules. The script that we are using is named `postProvisioning.sh`.
```sh
#!/bin/bash
# Install Docker Machine
curl -L https://github.com/docker/machine/releases/download/v0.4.0/docker-machine_linux-amd64 | sudo tee /usr/local/bin/docker-machine > /dev/null
sudo chmod u+x /usr/local/bin/docker-machine

# Install Firewall
sudo apt-get install -y ufw
# Allow SSH
sudo ufw allow ssh
# Allow HTTP and WS
sudo ufw allow 80/tcp
# Allow HTTPS and WSS
sudo ufw allow 443/tcp
# Allow Docker daemon port and forwarding policy
sudo ufw allow 2376/tcp
sudo sed -i -e "s/^DEFAULT_FORWARD_POLICY=\"DROP\"/DEFAULT_FORWARD_POLICY=\"ACCEPT\"/" /etc/default/ufw
# Enable and reload
yes | sudo ufw enable
sudo ufw reload
```

We execute this script on both VM using simple SSH commands like so:
```sh
ssh -i ~/.vagrant.d/insecure_private_key vagrant@192.168.33.10 "bash -s" < ./postProvisioning.sh
ssh -i ~/.vagrant.d/insecure_private_key vagrant@192.168.33.11 "bash -s" < ./postProvisioning.sh
```

### Reference your production host as a Docker Machine
In this example, we are using a VPS from OVH with a pre-installed Ubuntu 15.05
with Docker. These VPS starts at 2.99€ (around $3.5) per month and comes with
interesting features such as Anti-DDos, real time monitoring, ...

Preinstalled VPS comes with an OpenSSH access. Therefore, we will be using
the **generic-ssh** driver for our Docker Machine just like we did for the
Vagrant VM for development and pre-production.


`ssh root@example.com "bash -s" < ./provisioning.sh`

@TODO

### Creating your local registry
In your first terminal session, activate your development Docker Machine:
```sh
eval "$(docker-machine env dev)"
```
> If you are using [Fish](http://fishshell.com/) like me, use the following command:
  `eval (docker-machine env dev)`.

Now, we will use the development Docker Machine as our local registry:
```sh
docker run -d -p 5000:5000 --name registry registry:2
```

### Building Mongo
@TODO

- Oplog
- Authentication

### Building Meteor
@TODO

- Settings without importing them
- No demeteorizer

### Building NGinx
@TODO

- Cache Meteor static files

### Launching or refreshing your application
@TODO

- docker-compose
- systemd startup script: autostart your container


### Tagging version of your containers
@TODO

### Secure NGinx
@TODO

- Case of the development version (self signed certificate)
- Case of a bought certificate + verification text
- Proxy HTTP for one file, rewrite for HTTP to HTTPS

### Scale Mongo
@TODO

### Scale Meteor
@TODO

### Backup Mongo data
@TODO

### Update your Docker hosts
@TODO

### Docker clean-up
@TODO

http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers/23540202#23540202


### Links
* [Homebrew](http://brew.sh/)
* [Caskroom](https://github.com/caskroom/homebrew-cask)
* [Docker documentation](https://docs.docker.com/)
* [Docker Installation on Ubuntu](https://docs.docker.com/installation/ubuntulinux)
* [Secure Docker](https://docs.docker.com/articles/https/)
* [OpenSSL Howto](https://www.madboa.com/geek/openssl/)
* [Control and configure Docker with Systemd](https://docs.docker.com/articles/systemd/)
* [How to configure Docker on Ubuntu 15.04 (workaround)](http://nknu.net/how-to-configure-docker-on-ubuntu-15-04/)
* [Ulexus/Meteor: A Docker container for Meteor](https://hub.docker.com/r/ulexus/meteor/)
* [VPS SSD at OVH](https://www.ovh.com/fr/vps/vps-ssd.xml).
