## Devops on OSX with Docker set for Ubuntu 15.04
### Introduction
While using Meteor in development is an easy task and deploying it on Meteor's
infrastructure is a no brainer, things may start to get messy if you need to
deploy it, secure it and scale it on your cloud. Especially if your customer
imposes you a specific constraint on cloud sovereignty.

I hope that this tutorial will lead you on the appropriate tracks.

### Versions applied in this tutorial
As you may need to update this tutorial for your own DevOps use cases, here is
the complete list of versions used in this tutorial:

* OSX 10.10.5 as the development platform
* Ubuntu 15.04 as Docker host system
* Debian Jessie 7 as Docker container system
* Docker 1.8.1
* Docker Registry 2
* Docker Machine 0.4.1
* Docker Compose 1.4.0
* VirtualBox 5.0.2
* Meteor 1.1.0.3
* NGinx 1.9.4-1
* NodeJS 0.10.40
* Mongo 3.0.6 - WiredTiger

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

For easing the access to VM and servers, we are using an SSH key installer:
```sh
brew install ssh-copy-id
```

For parsing and querying JSON produced by Docker, we are using `./jq`:
```sh
brew install jq
```

### Create your virtual machines as Docker Machine
Create a `Vagrantfile` that matches your production environment.
Here, we are using an Ubuntu 15.04 with Docker pre-installed.
```ruby
hosts = {
  "dev" => "192.168.1.50",
  "pre" => "192.168.1.51"
}

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.ssh.insert_key = false
  hosts.each do |name, ip|
    config.vm.define name do |vm|
      vm.vm.hostname = "%s.example.org" % name
      vm.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: ip
      #vm.vm.network "private_network", ip: ip
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
# Set Docker daemon with the following properties:
# * Daemon listen to external request and is exposed on port 2376, the default Docker port.
# * Docker uses the AUFS driver for file storage.
# * Daemon uses Docker's provided certification chain.
# * Dameon has a generic label.
# * Daemon is able to resolve DNS query using Google's DNS.
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --storage-driver aufs --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic --dns 8.8.8.8 --dns 8.8.4.4"'  | sudo tee /etc/default/docker
sudo systemctl daemon-reload
sudo systemctl restart docker
# Enable Docker on server reboot
sudo systemctl enable docker
# Remove and clean unused packages
sudo apt-get autoremove -y
sudo apt-get autoclean -y
```

Now, we are starting our virtual server and declare it as a Docker Machine:
```sh
vagrant up --no-provision
```

Open 3 terminal sessions. In the first session, launch the following commands:
```sh
docker-machine -D create -d generic \
  --generic-ip-address 192.168.1.50 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  dev
```

In the second session, launch the following commands:
```sh
docker-machine -D create -d generic \
  --generic-ip-address 192.168.1.51 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  pre
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
  (leading to the message `Daemon not responding yet: dial tcp 192.168.33.X:2376: connection refused`).
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
ssh -i ~/.vagrant.d/insecure_private_key vagrant@192.168.1.50 "bash -s" < ./postProvisioning.sh
ssh -i ~/.vagrant.d/insecure_private_key vagrant@192.168.1.51 "bash -s" < ./postProvisioning.sh
```

Now you can access your VM either via Docker, Vagrant and plain SSH. To finish our
VM configuration, we are going to allow full root access to the VM without requiring
to use password. For that, you need a public and a private SSH keys on your local
machine. If you haven't done it before simply use the following command:
```
ssh-keygen -t rsa
```

Now, using Vagrant, copy the content of your ` ~/.ssh/id_rsa.pub` in each of the
VM's `/root/.ssh/authorized_key`.

### Reference your production host as a Docker Machine
In this example, we are using a VPS from OVH with a pre-installed Ubuntu 15.04
with Docker. These VPS starts at 2.99€ (around $3.5) per month and comes with
interesting features such as Anti-DDos, real time monitoring, ...

Preinstalled VPS comes with an OpenSSH access. Therefore, we will be using
the **generic-ssh** driver for our Docker Machine just like we did for the
Vagrant VM for development and pre-production. And like before, we are using
2 terminal sessions to overcome the Docker installation issue on Ubuntu 15.04.

In the first terminal session, we setup a root SSH access without password like so:
```
ssh-copy-id root@X.X.X.X
# Now, you should check if your key is properly copied
ssh root@X.X.X.X "cat /root/.ssh/authorized_keys"
cat ~/.ssh/id_rsa.pub
# These 2 last commands should return the exact same key
```
> I've been tricked by some `ssh-user-agent` issue there. Docker wasn't reporting
  any issue even in debug mode and was just exiting with a default error code.
  So, be careful that your public key is exactly the same on your local machine,
  your VM and your production host.

Next and still on the same terminal session, we declare our production host :
```sh
docker-machine -D create -d generic \
  --generic-ip-address X.X.X.X \
  --generic-ssh-user root \
  prod
```

And on the second terminal session, when the message
`Daemon not responding yet: dial tcp X.X.X.X:2376: connection refused` appears
on the first session, we launch:
```sh
ssh root@X.X.X.X "bash -s" < ./provisioning.sh
```

The last remaining step consists into solidifying our security by enabling
a firewall on the host and removing the old packages:
```sh
ssh root@X.X.X.X "bash -s" < ./postProvisioning.sh
```

### Creating your own registry
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

For making it visible to our preproduction VM, we need to update our default
firewall rules:
```sh
ssh root@192.168.1.50 ufw allow 5000
```

Now we are editing our `/etc/default/docker` configuration file for adding this
insecure registry in both our development and preproduction VM with this new
flag:
```sh
# On 192.168.1.50 & 192.168.1.51, in /etc/default/docker, we add in DOCKER_OPTS:
--insecure-registry 192.168.1.50:5000
```

We need to restart our Docker daemon and restart the Docker registry on the
development VM:
```sh
ssh root@192.168.1.50 systemctl restart docker
ssh root@192.168.1.51 systemctl restart docker
eval "$(docker-machine env dev)"
docker start registry
```

Our final step in the registry management is to login your preproduction VM and
your production server to Docker Hub using your Docker credential.
```sh
eval "$(docker-machine env pre)"
docker login
eval "$(docker-machine env prod)"
docker login
```

> Note that our registry isn't published outside our LAN. This makes it unusable
  for our production host. This development chain uses Docker Hub for publishing
  your images. Exposing this private registry to the outside world would require
  some additional configurations to tighten its security and server with a
  publicly exposed IP. While you could solely rely on Docker Hub for publishing
  your images, pushing and pulling to the outside world of your LAN are lengthy
  operations though lighten since Docker 1.6 and Docker Registry 2.

### Building Mongo
First things, we backup our current Mongo data. This is done outside of any
Docker container as we don't want to put user's data into our Docker images:
```sh
# Set the host
eval "$(docker-machine env dev)"
# In BASH
VOLUME=`docker inspect docker_db_1 | jq '.[0] | {Source: .Mounts[0].Source} | .Source'`
# In Fish
set VOLUME (docker inspect docker_db_1 | jq '.[0] | {Source: .Mounts[0].Source} | .Source')
# Make a full copy of your host's data on your local machine
scp -r root@192.168.1.50:$VOLUME backup
```

> Repeat this procedure on all your hosts :development, preproduction, production.

Our `mongo/Dockerfile` is based on Mongo's official one. It adds to the
picture the configuration of small ReplicaSet for making OPLOG available:
```
# Based on: https://github.com/docker-library/mongo/blob/d5aca073ca71a7023e0d4193bd14642c6950d454/3.0/Dockerfile
FROM debian:wheezy
MAINTAINER Pierre-Eric Marchandet <pemarchandet@gmail.com>

# Update system
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y -qq --no-install-recommends && \
    apt-get install -y -qq --no-install-recommends apt-utils && \
    apt-get install -y -qq --no-install-recommends \
      ca-certificates curl psmisc apt-utils && \
    apt-get autoremove -y -qq && \
    apt-get autoclean -y -qq && \
    rm -rf /var/lib/apt/lists/*

# Grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -sS -o /usr/local/bin/gosu -L "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" && \
    curl -sS -o /usr/local/bin/gosu.asc -L "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu

# Install MongoDB
ENV MONGO_MAJOR 3.0
ENV MONGO_VERSION 3.0.6
RUN groupadd -r mongodb && \
    useradd -r -g mongodb mongodb && \
    apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/$MONGO_MAJOR main" > /etc/apt/sources.list.d/mongodb-org.list && \
    apt-get update && \
    apt-get install -y -qq --no-install-recommends \
      mongodb-org=$MONGO_VERSION \
      mongodb-org-server=$MONGO_VERSION \
      mongodb-org-shell=$MONGO_VERSION \
      mongodb-org-mongos=$MONGO_VERSION \
      mongodb-org-tools=$MONGO_VERSION && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/mongodb && \
    mv /etc/mongod.conf /etc/mongod.conf.orig && \
    apt-get autoremove -y -qq && \
    apt-get autoclean -y -qq && \
    rm -rf /var/lib/apt/lists/* && \
    # Prepare environment for Mongo daemon: Use a Docker Volume container
    mkdir -p /db && chown -R mongodb:mongodb /db

# Launch Mongo
COPY mongod.conf /etc/mongod.conf
CMD ["gosu", "mongodb", "mongod", "-f", "/etc/mongod.conf"]
```

We need a configuration file for this Docker image to be built `mongo/mongod.conf`:
```
storage:
  dbPath: "/db"
  engine: "wiredTiger"
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
    collectionConfig:
      blockCompressor: snappy
replication:
  oplogSizeMB: 128
  replSetName: "rs0"
net:
  # bindIp: 127.0.0.1
  port: 27017
  wireObjectCheck : false
  unixDomainSocket:
    enabled : true
```

We could build this image and run it, but I prefer using a Docker Compose file.
These file eases the process of build and run of your Docker images acting as
a project file when multiple Docker images are required to work together for an
application. Here's the minima `docker-compose.yml` that we will enrich in the
next steps of this tutorial:
```
db:
  build: mongo
  volumes:
    - /var/db:/db
  expose:
    - "27017"
```

Before building or launching this Docker image, we need to prepare the
volume on each host that receives and persists Mongo's data:
```sh
ssh root@192.168.1.50 "mkdir /var/db; chmod go+w /var/db"
ssh root@192.168.1.51 "mkdir /var/db; chmod go+w /var/db"
ssh root@X.X.X.X "mkdir /var/db; chmod go+w /var/db"
```

For building our Mongo Docker image:
```sh
docker-compose build db
# Or even faster, for building and running
docker-compose up -d db
```

And once it's running, initialize a single instance ReplicaSet for making
Oplog tailing available:
```sh
docker-compose run db mongo db:27017/admin --quiet --eval "rs.initiate(); rs.conf();"
```

Some useful commands while developing a container:
```sh
# Access to a container in interactive mode
docker run -ti -P docker_db

# In BASH
# Delete all stopped containers
docker rm $(docker ps -a -q)
# Delete all images that are not being used in a running container
docker rmi $(docker images -q)
# Delete all images that failed to build (untagged images)
docker rmi $(docker images -f "dangling=true" -q)

# In Fish
# Delete all stopped containers
docker rm (docker ps -a -q)
# Delete all images that are not being used in a running container
docker rmi (docker images -q)
# Delete all images that failed to build (dangling images)
docker rmi (docker images -f "dangling=true" -q)
```

### Building Meteor
@TODO

- Settings without importing them

### Building NGinx


Ssl self-signed certificate
openssl req -nodes -new -x509 -keyout server.key -out server.cert



# Server certificate authority
echo "MyPassphrase" > passphrase.txt
openssl genrsa -aes256 -passout file:passphrase.txt -out ca-key.pem 4096
openssl req -passin file:passphrase.txt -subj '/C=FR/ST=Paris/L=Paris/CN=192.168.1.50'  -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
# Server certificate
openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=192.168.1.50" -sha256 -new -key server-key.pem -out server.csr
echo subjectAltName = IP:192.168.1.50,IP:127.0.0.1 > extfile.cnf# openssl x509 -passin file:passphrase.txt -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
# Client certificate
openssl genrsa -out key.pem 4096
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -passin file:passphrase.txt -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf
# Clean up CSR
rm -v client.csr server.csr # Secure file access
chmod -v 0400 ca-key.pem key.pem server-key.pem
chmod -v 0444 ca.pem server-cert.pem cert.pem


ssh root@192.168.1.50 "mkdir /var/cache; chmod go+w /var/cache"
ssh root@192.168.1.50 "mkdir /var/tmp; chmod go+w /var/tmp"

ssh root@192.168.1.51 "mkdir /var/cache; chmod go+w /var/cache"
ssh root@192.168.1.51 "mkdir /var/tmp; chmod go+w /var/tmp"

ssh root@X.X.X.X "mkdir /var/cache; chmod go+w /var/cache"
ssh root@X.X.X.X "mkdir /var/tmp; chmod go+w /var/tmp"

Volumes + chmod
    - /var/cache:/var/cache
    - /var/tmp:/var/tmp


@TODO

- Rework the case of separation in the import (server vs web.app stuff)
- Cache NodeJS Meteor response (other HTML + CSS + JS)
- 404, 50X
- Stop form spamming
- https://www.tollmanz.com/http2-nghttp2-nginx-tls/

- Case of the development version (self signed certificate)
- Case of a bought certificate + verification text
- Proxy HTTP for one file, rewrite for HTTP to HTTPS


### Launching or refreshing your application
@TODO

- docker-compose
- restart sur Meteor : à cause de Stylus, Sass, ...
- systemd startup script: autostart your container

### Mongo backups
@TODO


### Tagging version of your containers
@TODO


### Links
Informations used for this tutorial:
* [Homebrew](http://brew.sh/)
* [Caskroom](https://github.com/caskroom/homebrew-cask)
* [Easy sending your public SSH key to your remote servers](http://pem-musing.blogspot.fr/2014/05/easy-sending-your-public-ssh-key-to.html)
* [Docker documentation](https://docs.docker.com/)
* [Docker Installation on Ubuntu](https://docs.docker.com/installation/ubuntulinux)
* [Secure Docker](https://docs.docker.com/articles/https/)
* [The dangers of UFW + Docker](http://blog.viktorpetersson.com/post/101707677489/the-dangers-of-ufw-docker)
* [OpenSSL Howto](https://www.madboa.com/geek/openssl/)
* [Control and configure Docker with Systemd](https://docs.docker.com/articles/systemd/)
* [How to configure Docker on Ubuntu 15.04 (workaround)](http://nknu.net/how-to-configure-docker-on-ubuntu-15-04/)
* [Ulexus/Meteor: A Docker container for Meteor](https://hub.docker.com/r/ulexus/meteor/)
* [VPS SSD at OVH](https://www.ovh.com/fr/vps/vps-ssd.xml)
* [Your Docker Hub account](https://docs.docker.com/docker-hub/accounts/)
* [Creating a single instance MongoDB replica set for Meteor](https://blog.kayla.com.au/creating-a-single-instance-mongodb-replica-set-for-meteor/)
* [jq is a lightweight and flexible command-line JSON processor](https://stedolan.github.io/jq/)
* [How to add environment variables to nginx.conf](https://gist.github.com/xaviervia/6adea3ddba269cadb794)
* [MongoDB configuration options](http://docs.mongodb.org/manual/reference/configuration-options/)
* [MongoDB sample YAML files](http://dba.stackexchange.com/questions/82591/sample-yaml-configuration-files-for-mongodb)
* [The magic of Meteor oplog tailing](http://projectricochet.com/blog/magic-meteor-oplog-tailing#.Vd3eRlNRQVw)
* [Docker: Containers for the Masses -- using Docker](http://patg.net/containers,virtualization,docker/2014/06/10/using-docker/)
* [How To Create an SSL Certificate on Nginx for Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04)
* [SSL and Meteor.js](http://joshowens.me/ssl-and-meteor-js/?utm_content=buffera7818&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer)

Going further:
* [Deploying HTTP/2 and Strong TLS with Nghttp2 and Nginx](https://www.tollmanz.com/http2-nghttp2-nginx-tls/)
* [HTTP/2.0 with Nginx & NGHTTP2](https://timnash.co.uk/http2-0-with-nginx-nghttp2/)
* [Un serveur MongoDB sécurisé sur Docker](http://pierrepironin.fr/docker-et-mongodb/)
* [Docker sans utilisateur root sur l'hôte et dans les containers](http://blog.zol.fr/2015/08/06/travailler-avec-docker-sans-utilisateur-root/)
