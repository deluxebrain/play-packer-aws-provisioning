# install PowerShell 5 and Windows Management Framework
choco install powershell -y

# Install NuGet
Get-PackageProvider -Name NuGet -ForceBootstrap

# Trust the Microsoft PowerShell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

