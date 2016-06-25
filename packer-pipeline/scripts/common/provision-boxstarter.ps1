# Read this link to understand why this looks the way it does!
# https://github.com/mwrock/boxstarter/issues/121

Import-Module Boxstarter.Chocolatey
Import-Module "$($Boxstarter.BaseDir)\Boxstarter.Common\boxstarter.common.psd1"

$secpasswd = ConvertTo-SecureString "FooBar123!@$" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("packer", $secpasswd)

Write-Host "Creating Boxstarter task to wrap package install"
try
{
  Create-BoxstarterTask $credential
}
catch
{
  Write-Host "Error occured: $_"
  exit 1
}

Write-Host "Running in Boxstarter packages"
try
{
  Install-BoxstarterPackage -Verbose -PackageName c:\\tmp\\boxstarter\\boxstarter.ps1 # -DisableReboots
}
catch
{
  Write-Host "Error occured: $_"
  exit 1
}

Write-Host "Removing wrapper task"
try
{
  Remove-BoxstarterTask
}
catch
{
  Write-Host "Error occured: $_"
  # DONT EXIT
}

Write-Host "All done!"
exit 0

