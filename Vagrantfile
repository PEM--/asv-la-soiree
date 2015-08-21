hosts = {
  "dev" => "192.168.33.10"
}

# hosts = {
#   "dev" => "192.168.33.10",
#   "preprod" => "192.168.33.11"
# }


# $provisioningScript = <<SCRIPT
# curl -sSL https://get.docker.com/ | sh
# sudo apt-get -y upgrade
# sudo usermod -aG docker vagrant
#
#
# # Server certificate authority
# openssl genrsa -aes256 -passout file:passphrase.txt -out ca-key.pem 4096
# openssl req -passin file:passphrase.txt -subj '/C=FR/ST=Paris/L=Paris/CN=dev.example.com'  -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
# openssl genrsa -out server-key.pem 4096
# # Server certificate
# openssl req -subj "/CN=dev.example.com" -sha256 -new -key server-key.pem -out server.csr
# echo subjectAltName = IP:192.168.33.10,IP:127.0.0.1 > extfile.cnf
# openssl x509 -passin file:passphrase.txt -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
# # Client certificate
# openssl genrsa -out key.pem 4096
# openssl req -subj '/CN=client' -new -key key.pem -out client.csr
# echo extendedKeyUsage = clientAuth > extfile.cnf
# openssl x509 -passin file:passphrase.txt -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf
# # Clean up CSR
# rm -v client.csr server.csr
# # Secure file access
# chmod -v 0400 ca-key.pem key.pem server-key.pem
# chmod -v 0444 ca.pem server-cert.pem cert.pem
#
# echo 'DOCKER_OPTS="--tlsverify --tlscacert=/root/ca.pem --tlscert=/root/server-cert.pem --tlskey=/root/server-key.pem -H=0.0.0.0:2376"' | sudo tee /etc/default/docker
#
# # Overriding bad Systemd default in Docker startup script
# sudo mkdir -p /etc/systemd/system/docker.service.d
# echo -e '[Service]\n# workaround to include default options\nEnvironmentFile=-/etc/default/docker\nExecStart=\nExecStart=/usr/bin/docker -d -H fd:// $DOCKER_OPTS' | sudo tee /etc/systemd/system/docker.service.d/ubuntu.conf
# echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock --storage-driver aufs --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem --label provider=generic"'  | sudo tee /etc/default/docker
# sudo systemctl daemon-reload
# sudo systemctl restart docker
# # Enable Docker on server reboot
# sudo systemctl enable docker
# # Start Docker
# sudo systemctl start docker
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
