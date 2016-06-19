Configuration MyWebsite
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $MachineName,

    [string]$SourcePath,
    [string]$AppPoolName = "MyWebsite",
    [string]$WebAppPath = "c:\inetpub\wwwroot\MyWebsite",
    [string]$WebAppName = "MyWebsite",
    [string]$HostNameSuffix = "com",
    [string]$HostName = "MyWebsite.example.${HostNameSuffix}"
  )

  Import-DscResource -Module xWebAdministration
  Import-DscResource -Module xNetworking

  Write-Host "MyWebsite DSC Config :: MachineName=$MachineName, WebAppName=$WebAppName"
  
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
        Name = "WebFirewallOpen"
        Direction = "Inbound"
        LocalPort = "80"
        Protocol = "TCP"
        Action = "Allow"
        Ensure = "Present"
      }

      # Stop the default site
      xWebsite DefaultSite
      {
        Ensure = "Absent"
        Name = "Default Web Site"
        State = "Stopped"
        PhysicalPath = "c:\inetput\wwwroot"
      }

      File WebProject
      {
        Ensure = "Present"  
        SourcePath = $SourcePath
        DestinationPath = $WebAppPath
        Recurse = $true
        Type = "Directory"
      }

      xWebAppPool
      {
        Ensure = "Present"
        Name = $AppPoolName
        State = "Started"
        IdentityType = "ApplicationPoolIdentity"
      }

      xWebsite MyWebsite
      {
        Ensure = "Present"
        Name = $WebAppName
        ApplicationPool = $AppPoolName
        PhysicalPath = $WebAppPath
        State = "Started"
        LogPeriod = "Hourly"
        LogFormat = "W3C"
        BindingInfo = @(
          MSFT_xWebBindingInformation
          {
            Protocol = "http"
            Port = 80
            HostName = $HostName
            IPAddress = "*"
          }),
        AuthenticationInformation = @(
          MSFT_xWebAuthenticationInformation
          {
            Anonymous = $true
            Basic = $false
            Digest = $false
            Windows = $false
          })
  }
}
