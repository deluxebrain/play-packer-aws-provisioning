# Build pipeline

- install mono and nuget
- ensure path is set

  ```shell
  export PATH=$PATH:/Library/Frameworks/Mono.framework/Versions/Current/Commands
  ```

- Download and import trusted root certificates from Mozilla's LXR into mono's cert store

  ```shell
  sudo mozroots --import --sync
  ```

- Setup ```./tools/nuget/nuget/exe```

- Nuget packages can be `unzip`ped to inspect them

