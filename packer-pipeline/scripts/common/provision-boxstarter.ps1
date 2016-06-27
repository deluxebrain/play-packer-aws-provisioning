# Read this link to understand why this looks the way it does!
# https://github.com/mwrock/boxstarter/issues/121

Import-Module Boxstarter.Chocolatey
Import-Module "$($Boxstarter.BaseDir)\Boxstarter.Common\boxstarter.common.psd1"

$secpasswd = ConvertTo-SecureString "$env:BUILD_USER_PASSWORD" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("$env:BUILD_USER", $secpasswd)

Write-Host "Creating Boxstarter task to wrap package install"
$result = Create-BoxstarterTask $credential
jf ($result.Errors.Length -gt 0)
{
  Write-Host "Error occured creating Boxstarter task: $_"
  exit 1
}

Write-Host "Running in Boxstarter packages"
$result = Install-BoxstarterPackage -Verbose -PackageName c:\\tmp\\boxstarter\\boxstarter.ps1 # -DisableReboots
if ($result.Errors.Length -gt 0)
{
  Write-Host "Error occured running in Boxstarter packages: $_"
  exit 1
}

Write-Host "Removing wrapper task"
$result = Remove-BoxstarterTask
if ($result.Errors.Length -gt 0) 
{ 
  Write-Host "Error occured removing Boxstarter task - IGNORING: $_"
  # DONT EXIT
}

Write-Host "All done!"
exit 0

