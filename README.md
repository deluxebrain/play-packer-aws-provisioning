# play-packer-aws-provisioning
Using Packer to provision Windows servers in AWS


## PowerShell DSC

Packer is used to build up role specific boxes (via a build chain back to common *base* builds). These are then configurated per application using *PowerShell DSC*. 

PowerShell DSC makes it possible to declaratively set the desired state of a server, including Windows Features, Firewall rules, Web applications, etc.

DSC is powered by a large amount of third-party modules that are published by MSFT and the PowerShell community. These are available from the central PowerShell Gallery.


## Step through

1. Ensure the ```PACKER_CACHE_DIR``` environment variable is set

  Packer will use a local ```packer_cache``` directory by default for all temporary files. This includes the local file cache of ISO's specified using a url. 
  To prevent the git repository from becoming cluttered, and to allow these caches objects to be re-used across packer projects, the ```PACKER_CACHE_DIR``` environment variable needs to be set to point to a global cache directory.

  ```shell
  export PACKER_CACHE_DIR=/var/cache/packer/
  ```

2. Running the packer builds

  Example given for named ```basebox-vox``` builder

  ```shell
  packer build \
    -force                # overwrite all previous images
    -debug                # step through
    -only basebox-vbox    # only build the named builder
    packer-vbox.json      # packer build script 
    ```shell

3. Adding build to Vagrant

  The ```devbox-vbox``` builder has a ```post-processor``` to convert the build into a Vagrant ```box```.
  
  This box file can be added to Vagrant as follows:

  ```shell
  vagrant box add sample-app-1.0.0 /var/media/images/vagrant/sample-app-1.0.0/sample-app-1.0.0.box
  vagrant box list
  ```

  To remove it:

  ```shell
  vagrant box remove sample-app-1.0.0
  vagrant box list
  ```


