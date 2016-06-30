# DO NOT USE AS PART OF PACKER PIPELINE
# It appears that packer needs to know the admin password throughout the entire build pipeline
# I.e. even baking the admin password as the last step will cause the pipeline to fail

$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](get-content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        # Dont generate a random password
        $element.State="Disabled"
    }
}
$xml.Save($EC2SettingsFile)

net user Administrator "$env:ADMIN_PASSWORD"
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE
