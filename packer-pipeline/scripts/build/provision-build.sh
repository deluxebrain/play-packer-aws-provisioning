#!/bin/bash -x

echo "Provisioning build server"

set -e

echo "Installing git"
sudo yum install -y git
ssh-keyscan github.com >> ~/.ssh/known_hosts

echo "Installing remaining dependencies"
sudo yum install -y pwgen --enablerepo=epel
sudo yum install -y jq

sudo pip install awscli
sudo pip install ansible

echo "Installing Packer"
wget https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip
sudo unzip packer_0.10.1_linux_amd64.zip -d /usr/local/packer
rm packer_0.10.1_linux_amd64.zip
echo 'export PATH=/usr/local/packer:$PATH' | sudo tee /etc/profile.d/packer.sh 
sudo chmod a+x /etc/profile.d/packer.sh

echo "Installing Terraform"
wget https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip
sudo unzip terraform_0.6.16_linux_amd64.zip -d /usr/local/terraform
rm terraform_0.6.16_linux_amd64.zip
echo 'export PATH=/usr/local/terraform:$PATH' | sudo tee /etc/profile.d/terraform.sh

echo "Installing Golang"
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz
rm go1.6.2.linux-amd64.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' | sudo tee  /etc/profile.d/go.sh
mkdir -p ~/go/bin ~/go/pgk ~/go/src
echo 'export GOPATH=$HOME/go' | sudo tee --append /etc/profile.d/go.sh
echo 'export GOBIN=$GOPATH/bin' | sudo tee --append /etc/profile.d/go.sh
echo 'export PATH=$PATH:$GOBIN' | sudo tee --append /etc/profile.d/go.sh

echo "Reloading profile"
source /etc/profile

echo "Installing Packer dependencies"
git clone git@github.com:mefellows/packer-dsc.git ~/go/src/packer-dsc
cd ~/go/src/packer-dsc
make dev
sudo cp ~/go/bin/provisioner-dsc /usr/local/packer/packer-provisioner-dsc
cd ~






