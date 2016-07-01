# Build server

## Dependencies

- Python and pip
- AWS CLI
- Packer
- Terraform
- Packer-DSC plugin 

## Setup

### Setup AWS development environment

- Create key pair within AWS Console
- Save key pair off into ```~/.ssh/``` e.g. as ```~/.ssh/mykeypair.pem```
- Ensure permissions are correct on your ssh directory and keypairs
  - .ssh directory should be 700 (drwx------)
  - Public keys should be 644 (-rw-r--r--)
  - Private keys should be 600 (-rw-------)
- Create security group allowing ip address whitelisted access to EC2 instances

  e.g.
  ```shell
  Securiy group:  ingress-whitelist
  Description:    White list of ip addresses for remote conectivity
  Inbound rules:  SSH / My IP
                  RDP / My IP
                  5985 / My IP (winrm)
                  5986 / My IP (winrm over ssl)
                  All Traffic / My VPC
  ``

- Create security group allowing all outbound traffic.
  
  e.g.
  ```shell
  Security group: egress-all
  ```

### Fire up build server

- Create EC2 instance
- Create ssh config file to simplify ssh access

  e.g.
  *~/.ssh/config*
  ```shell
  Host myserver
    HostName <ip address>
    User ec2-user
    IdentityFile ~/.ssh/<mykeypair.pem>
    IdentitiesOnly yes
    ForwardAgent yes
  ```

### Install dependencies

- Connect to box

  ```shell
  ssh <myserver> # as defined in ~/.ssh/config 
  ```

- Ensure Python and Pip

  ```shell
  python --version
  pip --version
  ```

- AWS CLI and verify

  ```shell
  sudo pip install awscli
  aws --version
  ```

- Install Packer

  ```shell
  wget https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip
  
  # unzip to /usr/local/packer to make available to all users
  sudo unzip packer_0.10.1_linux_amd64.zip -d /usr/local/packer

  rm packer_0.10.1_linux_amd64.zip
  ```

- Setup Packer

  Need to setup the PATH to point to where Packer was installed. 
  Do this for all users as follows:

  ```shell
  echo 'export PATH=/usr/local/packer:$PATH' | sudo tee /etc/profile.d/packer.sh > /dev/null
  sudo chmod a+x /etc/profile.d/packer.sh
  ```

- Verify

  ```shell
  exit
  ssh <myserver>
  packer --version
  ```shell

- Install Terraform

  ```shell
  wget https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip
  sudo unzip terraform_0.6.16_linux_amd64.zip -d /usr/local/terraform
  rm terraform_0.6.16_linux_amd64.zip
  ```

- Setup Terraform

  ```shell
  echo 'export PATH=/usr/local/terraform:$PATH' | sudo tee /etc/profile.d/terraform.sh > /dev/null
  sudo chmod a+x /etc/profile.d/terraform.sh
  ```

- Verify

  ```shell
  exit
  ssh <myserver>
  terraform --version
  ```shell

- Install go

  ```shell
  wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz
  rm go1.6.2.linux-amd64.tar.gz
  echo 'export PATH=/usr/local/go/bin:$PATH' | sudo tee /etc/profile.d/go.sh
  ```

- Test go

  ```shell
  exit
  ssh <myserver>
  go version
  ```

- Setup go environment

  Setup workspace:

  ```shell
  mkdir -p ~/go/bin ~/go/pgk ~/go/src
  echo 'export GOPATH=$HOME/go' | sudo tee --append /etc/profile.d/go.sh > /dev/null
  echo 'export GOBIN=$GOPATH/bin' | sudo tee --append /etc/profile.d/go.sh > /dev/null
  echo 'export PATH=$PATH:$GOBIN' | sudo tee --append /etc/profile.d/go.sh > /dev/null
  ```

- Install git

  ```shell
  sudo yum install -y git
  ```

- Add github to known hosts to prevent being asked to verify authenticity when peforming a ```git clone```

  ```shell
  ssh-keyscan github.com >> ~/.ssh/known_hosts
  ```

- Install packer-dsc packer plugin
  
  ```shell
  git clone git@github.com:mefellows/packer-dsc.git ~/go/src/packer-dsc
  cd ~/go/src/packer-dsc
  make dev
  sudo cp ~/go/bin/provisioner-dsc /usr/local/packer/packer-provisioner-dsc
  ```

### Setup packer pipeline

- Install pwgen (used in pipeline to generate temp passwords)

  ```shell
  sudo yum install -y pwgen
  ```

- Install jq (used nearly everywhere)

  ```shell
  sudo yum install -y jq
  ```

- Install Ansible

  ```shell
  sudo yum install -y ansible
  ```

- Setup ```~/.aws/``` and ```~/.secrets/```















