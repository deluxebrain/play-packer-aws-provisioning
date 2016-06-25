# Install Chocolatey
(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

# Reload profile
. $profile

# Disable Windows Updates
cmd /c reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f

# Set TZ
tzutil /s "UTC"

# Install-WindowsFeature Web-Server
# Install-WindowsFeature Web-Mgmt-Tools
# Install-WindowsFeature Web-App-Dev -IncludeAllSubFeature

# Boxstarter
choco install Boxstarter -y

# Make sure 7za is installed
choco install 7zip -y
choco install -y 7zip.commandline

# Core OS
choco install dotnet4.5 -y
choco install powershell4 -y

