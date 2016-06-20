# DSC Overview

## Suggested project structure

```shell
ProjectRoot/
  ./VagrantFile
  ./Application/
  ./DSC/
    ./manifests
      ./ApplicationConfig.ps1
      ./ApplicationConfigData.psd1
    ./mof/
```

### DSC glossary

1. DSC configuration file

  PowerShell script that contains the DSC DSL syntax and DSC resources to execute

2. DSC configuration data

  PowerShell data file or code block that defines node config data

3. DSC resource

  A PowerShell module that contains functions to bring a target code to a desired sate

4. DSC cmdlets

  PowerShell cmdlets to perform DSC operations

5. MOF file

  Compiled DSC configuration file. MOF ( Machine Object Format ) is a vendor-neutral and platform agnostic file format that was defined by the *Distributed Management Task Force (DMTF)*.


