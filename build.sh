#!/usr/bin/env bash

export EnableNuGetPackageRestore=true
nuget "Install" "FAKE" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
nuget "Install" "FSharp.Data" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
mono "./build/packages/FAKE/tools/Fake.exe" build.fsx "$1"

