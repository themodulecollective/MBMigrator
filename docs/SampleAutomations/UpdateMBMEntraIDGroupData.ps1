# Import MBM Module and Configuration
. "C:\Migration\Scripts\MBMConfiguration.ps1"

#Archive Old User Data
. "C:\Migration\Scripts\ArchiveData.ps1" -Operation EntraIDGroupData -AgeInDays 30

$OutputFolderPath = $MBMConfiguration.EntraIDGroupDataFolder
$CertificateThumbprint = $MBMConfiguration.CertificateThumbprint
$MBMModulePath = $MBMConfiguration.MBMModulePath

$tenants = @(
    @{
        TenantDomain = $MBMConfiguration.SourceTenantDomain
        TenantID = $MBMConfiguration.SourceTenantID
        AppID = $MBMConfiguration.SourceTenantReportingAppID
    }
    @{
        TenantDomain = $MBMConfiguration.TargetTenantDomain
        TenantID = $MBMConfiguration.TargetTenantID
        AppID = $MBMConfiguration.TargetTenantReportingAppID
    }
)


$Jobs = @(
    foreach ($t in $tenants) {
        $AppID = $t.AppID
        $TenantID = $t.TenantID
        Start-Job -Name "Export $($t.TenantDomain) EntraID Groups" -ScriptBlock { # thread job doesn't work for isolating the graph modules
            Import-Module $Using:MBMModulePath
            Import-Module OGraph
            Connect-OGgraph -TenantID $using:TenantID -ApplicationID $using:AppID -CertificateThumbprint $Using:CertificateThumbprint
            Export-EntraIDGroup -OutputFolderPath $Using:OutputFolderPath
        } 
    }
)

Wait-Job -Job $Jobs


#need to run Get-MaxLengthOfAttributes and refine target table
#need to add indexing

$newDataFiles = @(Get-ChildItem -Path $OutputFolderPath -Filter *EntraIDGroupsAsOf*.xml)
Update-MBMActiveDirectoryData -Operation EntraIDGroup -FilePath $newDataFiles.fullname -InformationAction Continue -Truncate
