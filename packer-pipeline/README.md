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

### Packer and WinRM

When packer provisions a Windows box, it waits for WinRM to become available before proceeding along the provisioners chain, and eventually rebooting.

As WinRM is needed for the build chain to proceed, it needs to be provisioned as part of the installation of the OS. 

For virtualbox images, this is done using the ```<FirstLogonCommands>``` within the autounattend file.

For aws images, this is done in the user-data file.

### Boxstarter

Boxstarter only really works when run locally on the box - i.e. not when used over winrm. 

For this reason, it should be limited to being used within the autounattend file or the user-data file.

It *can* be used across the build chain - but for anything that wont work over powershell remoting the actions need to be wrapped in a task. Additionally, there no real way to orchestrate the construction and removal of the task across reboots. I.e. - dont perform any reboots in the actions as the rest of the actions (post the reboot) wont happen.

Additionally, theres a bit of a clash between packer and Boxstarter where reboots are concerned. When Boxstarter is used from e.g. the autounattend file, the packer build pipeline effectively paused until winrm becomes available. This means that you can reboot the box as many times as you want from within Boxstarter **up to the point you enable winrm**.

When using Boxstarter from within the packer build pipeline, any reboots from within Boxstarter will cause subsequent packer commands to fail due to *pending restart*. Probably ways around this (e.g. sleeping the packer pipeline to allow the reboot to happen) - but best to just avoid it really.

### The packer build pipeline and winrm

The packer build pipeline is constructed from two main parts; the ```builder``` stage and the ```provisioning``` stage.

The ```builder``` stage is managed by the underlying hypervisor - configured via the packer builder json and the hypervisor specific build file (autounattend in the case of vbox, user-data in the case of aws, etc).

The ```provisioner``` stage is managed by packer, and is effectively a series of steps performed over ssh/winrm as configured in the associated packer template.

The question then is - when does the builder stage end and the provisioner stage begin?

This is an immensely important consideration - and has a certain amount of effect on how your build pipeline is put together. As soon as the configured connectivity has been established (winrm or ssh), packer will take over and start executing the provisioning pipeline.

I.e. - turning on winrm must be the last thing done in the build stage, and must be toggled off/on at any point where you need to pause the packer provisioning.

### Windows server RAM sizing

Windows Server 2012 r2 Windows updates fails for RAM sizing below 4GB.




