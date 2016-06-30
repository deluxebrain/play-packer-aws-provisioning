#!/bin/sh

export EnableNuGetPackageRestore=true
mono ./tools/nuget/nuget.exe "Install" "FAKE" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
mono ./tools/nuget/nuget.exe "Install" "FSharp.Data" "-OutputDirectory" "./build/packages" "-ExcludeVersion"
mono ./build/packages/FAKE/tools/Fake.exe build.fsx

