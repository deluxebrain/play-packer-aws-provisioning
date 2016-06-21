# Vagrantfile overview

## Enabling passwordless sudo

e.g. for updating the hosts file using *vagrant-hostmanager*.

1. Add the following to the sudoers file ( /etc/sudoers.d/vagrant_hostmanager ):

  ```shell
  Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp <home-directory>/.vagrant.d/tmp/hosts.local \
    /etc/hosts \
    %<admin-group> ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
  ```

  - Replace ```<home-directory>``` with the home directory
  - Replace ```<admin-group>``` with the group that is used to ```sudo``` access ( e.g. ```sudo```)
  - Add yourself to the admin group
    
    ```shell
    usermod -G <admin-group> <user-name>
    ```

