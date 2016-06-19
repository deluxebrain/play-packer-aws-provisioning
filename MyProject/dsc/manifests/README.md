# PowerShell DSC Configuration Data

## PSDscAllowPlainTextPassword

See: https://blogs.technet.microsoft.com/ashleymcglone/2015/12/18/using-credentials-with-psdscallowplaintextpassword-and-psdscallowdomainuser-in-powershell-dsc-configuration-data/

By default you need to encrypt passwords using a ```ConfigurationData``` structure and a certificate. This can be overriden using the ```PSDscAllowPlainTextPassword``` parameter by setting it to true.

### Encrypting credentials

See: https://msdn.microsoft.com/en-us/powershell/dsc/securemof?f=255&MSPPError=-2147217396

```shell
$cd = @{
  AllNodes = @(
    @{
      NodeName = 'localhost'
      CertificateFile = 'c:\PublicKeys\server1.cer'
    }
  )
}

