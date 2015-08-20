## Devops on OSX
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
```

Now, we are starting our virtual server and declare it as a Docker Machine:
```sh
vagrant up
vagrant provision
vagrant reload
docker-machine create -d generic \
  --generic-ip-address 192.168.33.10 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  dev
docker-machine create -d generic \
  --generic-ip-address 192.168.33.11 \
  --generic-ssh-user vagrant \
  --generic-ssh-key ~/.vagrant.d/insecure_private_key \
  preprod
```


### Links
* [Homebrew](http://brew.sh/)
* [Caskroom](https://github.com/caskroom/homebrew-cask)
* [Docker documentation](https://docs.docker.com/)
