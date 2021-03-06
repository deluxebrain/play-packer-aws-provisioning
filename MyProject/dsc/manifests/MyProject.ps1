Configuration MyProject
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MachineName,
    [string]$SourcePath
  )

  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  Import-DscResource -Module 'MyProjectApp'
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -Module 'xNetworking'

  Write-Host "MyWebsite DSC Config :: MachineName=$MachineName, WebAppName=$WebAppName"
  
  Node $MachineName
  {
      File DriveLetterConfig
      {
        Ensure = "Present"  
        SourcePath = "C:\tmp\deploy\ops\DriveLetterConfig.xml"
        DestinationPath = "C:\Program Files\Amazon\Ec2ConfigService\Settings\"
        Recurse = $false
        Type = "File"
      }

      WindowsFeature IIS
      {
        Ensure = "Present"
        Name = "Web-Server"
      }

      WindowsFeature IISManagerFeature
      {
        Ensure = "Present"
        Name = "Web-Mgmt-Tools"
      }

      xFirewall webFirewall
      {
        Ensure = "Present"
        Name = "WebFirewallOpen"
        Direction = "Inbound"
        LocalPort = "80"
        Protocol = "TCP"
        Action = "Allow"
      }

      xWebsite DefaultSite
      {
        Ensure = "Absent"
        Name = "Default Web Site"
        State = "Stopped"
        PhysicalPath = "c:\inetput\wwwroot"
      }

      MyProjectWeb sWebsite
      {
        MachineName = $MachineName
        SourcePath = $SourcePath
      }
  }
}
