
function Update-MBMFromExcelFile
{
    <#
    .SYNOPSIS
        Updates the MBM Database with Data from an MBM module supported Export- function which produces an XLSX file
    .DESCRIPTION
        Updates the MBM Database with Data from a flat xlsx file (simple single value attributes) export source such as Export-EntraIDUserDrive
    .EXAMPLE
        Update-MBMFromExcelFile -Operation UserDrive -filepath UserDriveData.xlsx -Truncate
        Updates the MBM Database with UserDrive data from teh file UserDriveData.xlsx
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [validateset('UserDrive','UserDriveDetail')]
        $Operation
        ,
        #
        [parameter(Mandatory)]
        [validatescript({Test-Path -Path $_ -PathType Leaf -Filter *.xlsx})]
        [string[]]$FilePath
        ,
        [switch]$Truncate
        ,
        [switch]$AutoCreate
        ,
        [switch]$Test
    )

    Import-Module dbatools

    $Configuration = Get-MBMConfiguration

    $dbiParams = @{
        SqlInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    $SourceData = @(Import-Excel -Path $FilePath)

    switch ($Operation)
    {
        'UserDrive'
        {
            #Update Graph User Drive Data
            $UserDrives = @($SourceData)
            Write-Information -MessageData 'Processing User Drive Data'
            $dTParams = @{
                Table = 'stagingUserDrive'
            }
            if ($Truncate)
            {$dTParams.Truncate = $true}
            if ($AutoCreate)
            {$dTParams.AutoCreate = $true}

            $property = @(
                'UserID'
                'UserPrincipalName'
                'createdDateTime'
                'description'
                'id'
                'lastModifiedDateTime'
                'name'
                'webUrl'
                'driveType'
                'createdBy'
                'lastModifiedBy'
                'owner'
                'quota'
            )
            $excludeProperty = @(
            )
            $customProperty = @(
            )

            $ColumnMap = [ordered]@{}
            @($property;$customProperty.foreach({$_.n})).foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $property = @($property.where({ $_ -notin $excludeProperty }))

            $sUserDrives = $UserDrives | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

            switch ($test)
            {
                $true
                {
                    @{
                        Map = $ColumnMap
                        Data = $sUserDrives
                        Table = Get-DbaDbTable @dbiParams -Table $dTParams.Table
                    }
                }
                $false
                {
                    $sUserDrives | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
                }
            }

        }
        'UserDriveDetail'
        {
            #Update Graph User Drive Data
            $UserDrives = @($SourceData)
            Write-Information -MessageData 'Processing User Drive Detail Data'
            $dTParams = @{
                Table = 'stagingUserDriveDetail'
            }
            if ($Truncate)
            {$dTParams.Truncate = $true}
            if ($AutoCreate)
            {$dTParams.AutoCreate = $true}

            $property = @(
                'Owner'
                'Title'
                'LastContentModifiedDate'
                'Url'
                'UsageInGB'
                'QuotaInGB'
            )
            $excludeProperty = @(
            )
            $customProperty = @(
            )

            $ColumnMap = [ordered]@{}
            @($property;$customProperty.foreach({$_.n})).foreach({ $ColumnMap.$_ = $_ })
            $dTParams.ColumnMap = $ColumnMap
            $property = @($property.where({ $_ -notin $excludeProperty }))

            $sUserDrives = $UserDrives | Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty)

            switch ($test)
            {
                $true
                {
                    @{
                        Map = $ColumnMap
                        Data = $sUserDrives
                        Table = Get-DbaDbTable @dbiParams -Table $dTParams.Table
                    }
                }
                $false
                {
                    $sUserDrives | ConvertTo-DbaDataTable | Write-DbaDataTable @dbiParams @dTParams
                }
            }

        }

    }
}