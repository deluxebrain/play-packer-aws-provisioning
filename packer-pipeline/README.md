# Packer build pipeline

## Packer plugins

### packer-dsc

This is not yet available via the usual packer plugin distribution model.

1. Setup ```go``` workspace

  E.g.
  ```shell
  ~/go/
    ./bin/
    ./pkg/
    ./src/
  ```

2. Setup up ```go``` environment

  ```shell
  export GOPATH=~/go;
  export GOBIN=$GOPATH/bin;
  export PATH=$PATH:$GOBIN;
  ```

  Install gox (cross compiler)

  ```shell
  go get github.com/mitchellh/gox
  ```

3. Get the source

  ```shell
  cd ~/go/src
  git clone https://github.com/mefellows/packer-dsc.git
  cd packer-dsc
  make dev
  ```

4. Install the plugin

  ```shell
  cp ~/go/bin/packer-provisioner-dsc ~/.packer.d/plugins
  ```

## Running a build

```shell
packer build -force -only devbox-vbox packer-vbox.json &> packer.log &
mt -cS log packer.log
```

Note this can take a long time - if you need to quit out (e.g. if its failing) hit ctrl-c. However, this will leave behind some mess that will prevent future builds working.

To fix:

```shell
rm -rf ~/VirtualBox/VMs/<name>/*
```

## Vagrant

1. Managing Vagrant boxes

  ```shell
  vagrant box list
  vagrant box remove <name>
  vagrant box add <name> <path>
  ```

2. Firing up boxes

  ```shell
  cd <path_to_vagrant_file>
  vagrant up --debug &> vagrant.log
  ```

3. Running just provisioning

  ```shell
  cd <path_to_vagrant_file>
  vagrant provision --provision-with dsc
  ```

4. Plugin management

  ```shell
  vagrant plugin list
  vagrant plugin show <name>
  vagrant plugin remove <name>
  vagrant plugin install <name>
  vagrant plugin install <path>
  ```

## Snippets

### Packer 

- How do I tell what my script is doing?
  
  Add ```-x``` to shebang

  ```shell
  #!/bin/bash -x
  ```




