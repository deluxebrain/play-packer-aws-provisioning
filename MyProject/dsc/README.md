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
    ./modules/
```

## DSC glossary

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

## Custom Powershell v4 DSC resources

A PowerShell v4 DSC resource contains one of more PowerShell modules contained within a wrapper manifest module. The manifest module declares the containing ```DSC Resource``` and the associated metadata required for loading of the contained modules.

### Directory structure

PowerShell v4 DSC resource **have a strict** directory structure:

```shell
$env:ProgramFIles\WindowsPowerShell\Modules\
  .\MyModule\
    .\MyModule.psd1
    .\DSCResources\
      .\MyModule_1\
        .\MyModule_1.psd1           # optional
        .\MyModule_1.psm1           # required
        .\MyModule_1.schema.psm1    # required
      .\MyModule_2\
```




