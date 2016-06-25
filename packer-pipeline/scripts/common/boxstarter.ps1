Disable-MicrosoftUpdate
Disable-InternetExplorerESC
Enable-RemoteDesktop
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder

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
