#!/usr/bin/env bash

export EnableNuGetPackageRestore=true
nuget "Install" "FAKE" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
#nuget "Install" "seek-dsc-networking" "-Version" "1.0.1" "-OutputDirectory" "Build/packages"
#nuget "Install" "seek-dsc-webadministration" "-Version" "1.0.1" "-OutputDirectory" "Build/packages"
nuget "Install" "FSharp.Data" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
mono "./build/packages/FAKE/tools/Fake.exe" build.fsx "$1"
