function Run-DesiredStateConfig {
  param (
    [string] $url
  )
  $config = [IO.Path]::GetFileNameWithoutExtension($url)
  $target = ('{0}\{1}.ps1' -f $env:Temp, $config)
  (New-Object Net.WebClient).DownloadFile($url, $target)
  Unblock-File -Path $target
  . $target
  $mof = ('{0}\{1}' -f $env:Temp, $config)
  & $config @('-OutputPath', $mof)
  Start-DscConfiguration -Path $mof -Wait -Verbose -Force
}

$configs = @(
  'https://raw.githubusercontent.com/MozRelOps/OpenCloudConfig/master/userdata/try-win2012-vs2013/resource-config.ps1',
  'https://raw.githubusercontent.com/MozRelOps/OpenCloudConfig/master/userdata/try-win2012-vs2013/service-config.ps1',
  'https://raw.githubusercontent.com/MozRelOps/OpenCloudConfig/master/userdata/try-win2012-vs2013/feature-config.ps1',
  'https://raw.githubusercontent.com/MozRelOps/OpenCloudConfig/master/userdata/try-win2012-vs2013/software-config.ps1'
)
foreach ($config in $configs) {
  Run-DesiredStateConfig -url $config
}