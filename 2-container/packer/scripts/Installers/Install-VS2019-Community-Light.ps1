################################################################################
##  File:  Install-VS2019.ps1
##  Desc:  Install Visual Studio 2019
################################################################################
$ErrorActionPreference = "Stop"

Import-Module -Name ImageHelpers -Force

$WorkLoads = '--includeRecommended ' + `
              '--add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools ' + `
              '--add Microsoft.Net.ComponentGroup.4.7.1.DeveloperTools ' + `
              '--add Microsoft.Net.Component.4.7.2.SDK ' + `
              '--add Microsoft.Net.Component.4.7.2.TargetingPack ' + `
              '--add Microsoft.Net.ComponentGroup.4.7.2.DeveloperTools ' + `
              '--add Microsoft.Net.ComponentGroup.4.7.DeveloperTools ' + `
              '--add Microsoft.VisualStudio.Component.AspNet45 ' + `
              '--add Microsoft.VisualStudio.Component.Debugger.JustInTime ' + `
              '--add Microsoft.VisualStudio.Component.DslTools ' + `
              '--add Microsoft.VisualStudio.Component.EntityFramework ' + `
              '--add Microsoft.VisualStudio.Component.LinqToSql ' + `
              '--add Microsoft.VisualStudio.Component.SQL.SSDT ' + `
              '--add Microsoft.VisualStudio.Component.PortableLibrary ' + `
              '--add Microsoft.VisualStudio.Component.TestTools.CodedUITest ' + `
              '--add Microsoft.VisualStudio.Component.TestTools.WebLoadTest ' + `
              '--add Microsoft.VisualStudio.Component.Workflow.BuildTools ' + `
              '--add Microsoft.VisualStudio.Workload.Data ' + `
              '--add Microsoft.VisualStudio.Workload.NetWeb ' + `
              '--add Microsoft.VisualStudio.Workload.Node '

$ReleaseInPath = "Community"
$BootstrapperUrl = "https://aka.ms/vs/16/release/vs_${ReleaseInPath}.exe"

# Install VS
Install-VisualStudio -BootstrapperUrl $BootstrapperUrl -WorkLoads $WorkLoads

# Find the version of VS installed for this instance
# Only supports a single instance
$vsProgramData = Get-Item -Path "C:\ProgramData\Microsoft\VisualStudio\Packages\_Instances"
$instanceFolders = Get-ChildItem -Path $vsProgramData.FullName

if ($instanceFolders -is [array])
{
    Write-Host "More than one instance installed"
    exit 1
}

$catalogContent = Get-Content -Path ($instanceFolders.FullName + '\catalog.json')
$catalog = $catalogContent | ConvertFrom-Json
$version = $catalog.info.id
$VSInstallRoot = "C:\Program Files (x86)\Microsoft Visual Studio\2019\$ReleaseInPath"
Write-Host "Visual Studio version ${version} installed"

# Initialize Visual Studio Experimental Instance
& "$VSInstallRoot\Common7\IDE\devenv.exe" /RootSuffix Exp /ResetSettings General.vssettings /Command File.Exit
