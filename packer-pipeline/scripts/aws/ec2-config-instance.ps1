# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html

# BundleConfig.xml
$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\BundleConfig.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "AutoSysprep")
    {
        # Dont run sysprep
        $element.State="No"
    }
    elseif ($element.name -eq "SetPasswordAfterSysprep")
    {
        # Don't mess with the administrator password
        $element.State="No"
    }
}
$xml.Save($EC2SettingsFile)

# Config.xml
$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        # Instances will generate the password from the keypair
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2SetComputerName")
    {
        # Set computer name to unique name based on IP address
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        # Still may need user data later on
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
