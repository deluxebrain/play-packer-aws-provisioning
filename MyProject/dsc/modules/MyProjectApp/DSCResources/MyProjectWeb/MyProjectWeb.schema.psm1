Configuration MyProjectWeb
{
  param 
  (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MachineName,
    [string]$SourcePath,
    [string]$AppPoolName = "MyWebsite",
    [string]$WebAppPath = "c:\inetpub\wwwroot\MyWebsite",
    [string]$WebAppName = "MyWebsite",
    [string]$HostNameSuffix = "com",
    [string]$HostName = "MyWebsite.example.${HostNameSuffix}"
  )

  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
  Import-DscResource -Module 'xWebAdministration'
  Import-DscResource -Module 'xNetworking'

  Write-Host "MyProjectWeb DSC Config :: MachineName=$MachineName, WebAppName=$WebAppName"
  
  Node $MachineName
  {
      File WebProject
      {
        Ensure = "Present"  
        SourcePath = $SourcePath
        DestinationPath = $WebAppPath
        Recurse = $true
        Type = "Directory"
      }

      xWebAppPool MyWebsite
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
        BindingInfo = @(
          MSFT_xWebBindingInformation
          {
            Protocol = "http"
            Port = 80
            HostName = $HostName
            IPAddress = "*"
          })
        AuthenticationInfo = MSFT_xWebAuthenticationInformation
        {
            Anonymous = $true
            Basic = $false
            Digest = $false
            Windows = $false
        }
    }
  }
}
