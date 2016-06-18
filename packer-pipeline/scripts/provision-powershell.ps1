# install PowerShell 5 and Windows Management Framework
Write-Host "Installing PowerShell"
choco install powershell -y

# Install NuGet
Write-Host "Installing NuGet"
Get-PackageProvider -Name NuGet -ForceBootstrap

# Trust the Microsoft PowerShell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Install DSC modules
Write-Host "Installing Third-Party DSC modules"
# https://github.com/PowerShell/xWebAdministration
Install-Module -Name xWebAdministration
# https://github.com/PowerShell/xNetworking
Install-Module -Name xNetworking
# List out all modules to verify install
Get-DscResource

