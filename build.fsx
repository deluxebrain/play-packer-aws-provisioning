#r "System.Net.Http.dll"
#r "Build/packages/FAKE/tools/FakeLib.dll"
#r "Build/packages/FSharp.Data/lib/net40/FSharp.Data.dll"
open System
open System.IO
open System.Net
open System.Net.Http
open System.Text.RegularExpressions
open Fake
open Fake.AssemblyInfoFile
open FSharp.Data
open FSharp.Data.JsonExtensions

let projectName = "MyProject"
let projectDescription = "My Project"
let authors = ["catonm"]
let applicationName = "MyApp"
let packageName = applicationName.ToLowerInvariant()
let streamKey = "se"

// Paths
let root = "./"
let buildDir = "./build/tmp/"
let packagingRoot = "./build/packaging/"
let deployDir = "./build/publish/"

let version = defaultArg BuildNumber "1.0.0"

tracefn "Version: %s" version

// Targets
Target "Clean" (fun _ ->
    CleanDirs [ buildDir; packagingRoot; deployDir ]
)

let dependencies = [ ]

Target "CreatePackage" (fun _ ->
    let packageDir = "./build/packages/"
    let autoDep x = x, GetPackageVersion packageDir x
    let dependenciesWithVersion = dependencies |> List.map autoDep

    projectName
    |> sprintf "%s.nuspec"
    |> NuGet (fun p ->
        {p with
            Authors = authors
            Project = packageName
            Description = projectDescription
            OutputPath = deployDir
            WorkingDir = root
            Version = version
            Dependencies = dependenciesWithVersion
            Files = [(@"build/tmp/**", Some "lib", None)
                     (@"MyProject/dsc/modules/**/*", Some "dsc", None)
                     (@"MyProject/dsc/manifests/*", Some "dsc", None)
                     (@"MyProject/Install/*", Some "tools", None)]

            Publish = false })
)

Target "CreateSourceZip" (fun _ ->
    let copyPackage name =
        let pkg = sprintf "**/%s*.nupkg" name
        !! pkg
        |> Copy deployDir

    dependencies
    |> List.iter copyPackage

    !! (deployDir @@ "*.nupkg")
    |> Zip deployDir (deployDir @@ "source.zip")
)

Target "All" DoNothing
//Target "RestorePackages" DoNothing

// Dependencies
"Clean"
    ==> "CreatePackage"
    ==> "CreateSourceZip"
    ==> "All"


// start build
RunTargetOrDefault "All"
