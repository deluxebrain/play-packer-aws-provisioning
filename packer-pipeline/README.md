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
packer build -force -only devbox-vbox packer-vbox.json &> packer.log
```

