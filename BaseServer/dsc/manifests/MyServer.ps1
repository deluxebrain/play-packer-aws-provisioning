Configuration MyServer
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MachineName
  )

  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -Module 'xNetworking'

  Write-Host "MyServer DSC Config :: MachineName=$MachineName"
  
  Node $MachineName
  {
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
  }
}
