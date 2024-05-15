function Update-MBMPermissionData {
    <#
    .SYNOPSIS

    .DESCRIPTION
        Takes a csv with Mailbox permissions and creates the stagingpermissions table in the migration database
    .EXAMPLE
        Update-MBMPermissionData -InputFolderPath "C:\Users\Username\Documents"
        Takes a csv with Mailbox permissions from the input folder path and creates the stagingpermissions table in the migration database
    #>

    [cmdletbinding()]
    param(
        <#
        [parameter(Mandatory)]
        [validateset('Permission')]
        #'ADUser', 'AzureADUser', , 'CASMailbox', 'MailboxStatistics', 'VIP', 'Pilot', 'WaveAssignments', 'WaveExceptions', 'MMLStatic', 'MMLExport'
        $Operation
        ,
#>
        #
        [parameter(Mandatory)]
        $InputFolderPath
        ,
        #
        [switch]$Truncate
    )

    #Import-Module ImportExcel
    Import-Module dbatools

    $Configuration = Get-MBMConfiguration

    $dbiParams = @{
        SqlInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    $InputFiles = @(Get-ChildItem -Path $InputFolderPath -Filter *ExportedExchangePermissions*.csv)

    $SourceData = @(
        foreach ($f in $InputFiles) {
            Import-Csv -Path $f.fullname
            #| Select-Object -excludeProperty IsAutoMapped,IsInherited -property *,@{n='IsAutoMapped';e={switch($_.IsAutoMapped){'FALSE'{0}'TRUE'{1}DEFAULT{$null}}}},@{n='IsInherited';e={switch($_.IsInherited){'FALSE'{0}'TRUE'{1}DEFAULT{$null}}}}
        }
    )

    #Update Permissions Data
    Write-Information -MessageData 'Processing Permissions Data'
    $dTParams = @{
        Table = 'stagingPermissions'
    }
    $property = @(@(Get-MBMColumnMap -tabletype stagingPermissions).Name)
    $ColumnMap = @{}
    $property.foreach({ $ColumnMap.$_ = $_ })
    $dTParams.ColumnMap = $ColumnMap
    if ($Truncate)
    { $dTParams.Truncate = $true }
    $excludeProperty = @()
    $property = @($property.where({ $_ -notin $excludeProperty }))
    $customProperty = @(    )

    $SourceData |
    Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) |
    ConvertTo-DbaDataTable |
    Write-DbaDataTable @dbiParams @dTParams
}