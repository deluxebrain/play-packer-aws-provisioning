# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html
$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        # Generate a random password with each launch
        # Important when creating AMI's from instances
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2SetComputerName")
    {
        # Set computer name to unique name based on IP address
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        # Allow user data to be run in subsequent first launch
        # Important with creating AMI's from instances
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2SetDriveLetter")
    {
        # Sets drive letters of the mounted volumes based on DriveLetterConfig.xml
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2DynamicBootVolumeSize")
    {
        # Expand boot volume to include any unpartitioned space
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)
