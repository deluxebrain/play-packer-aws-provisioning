# Boxstarter WinConfig features to customize the Windows experience
# http://boxstarter.org/WinConfig
Disable-MicrosoftUpdate
Disable-InternetExplorerESC
Disable-BingSearch
Enable-RemoteDesktop
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder

# TODO - not working ...
# Install Powershell 5
# Write-BoxstarterMessage "Installing Powershell and WMI"
# choco install powershell -y

# Install critical Windows udpates
Write-BoxstarterMessage "Installing critical Windows updates"
Install-WindowsUpdate -AcceptEula

Write-BoxstarterMessage "Checking if reboot is required"
if (Test-PendingReboot)
{ 
  Write-Host "Rebooting"
  Invoke-Reboot 
}

Write-BoxstarterMessage "All done!"
