# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/UsingConfig_WinAMI.html
$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        # Dont generate a random password
        $element.State="False"
    }
}
$xml.Save($EC2SettingsFile)

net user Administrator "$env:ADMIN_PASSWORD"
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE
