function Update-CustomData
{
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [validateset('PersonDetails','ManagerAssistant')]
        $Operation
        ,
        [parameter(Mandatory)]
        $InputFilePath
        ,
        [switch]$Truncate
    )

    #Import-Module ImportExcel
    Import-Module dbatools

    $Configuration = Get-MBMConfiguration
    $dbiParams = @{
        SqlInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    

    $SourceData = Import-Excel -Path $InputFilePath

    switch ($Operation)
    {
        'PersonDetails'
        {
            Write-Information -MessageData 'Processing PersonDetails Data'
            $dTParams = @{
                Table = 'PersonDetails'
            }
            if ($Truncate)
            {
                Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE PersonDetails'
            }
            $property = @(@(Get-CustomColumnMap -tabletype PersonDetails).Name)
            $ColumnMap = @{}
            $property.foreach({$ColumnMap.$_ = $_})
            $dTParams.ColumnMap = $ColumnMap
            $excludeProperty = @(
                'BusinessUnit'
                'Department'
            )
            $property = @($property.where({$_ -notin $excludeProperty}))
            $customProperty = @(
                @{n = 'BusinessUnit'; e= {$_.OrgUnitShortName.split('-')[0]}}
                @{n = 'Department'; e= {$_.OrgUnitShortName.split('-')[1]}}
            )
            
            $SourceData |
            Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) |
            ConvertTo-DbaDataTable |
            Write-DbaDataTable @dbiParams @dTParams
            #$MailboxesUpdates = Invoke-DbaQuery @dbiParams -Query $(Get-Content -Path '..\SQL\MergeExchangeMailboxes.sql' -Raw) -As PSObject
        }
        'ManagerAssistant'
        {
            Write-Information -MessageData 'Processing ManagerAssistant Data'
            $dTParams = @{
                Table = 'ManagerAssistant'
            }
            if ($Truncate)
            {
                Invoke-DbaQuery @dbiParams -Query 'TRUNCATE TABLE ManagerAssistant'
            }
            $property = @(@(Get-CustomColumnMap -tabletype ManagerAssistant).Name)
            $ColumnMap = @{}
            $property.foreach({$ColumnMap.$_ = $_})
            $dTParams.ColumnMap = $ColumnMap
            $excludeProperty = @()
            $property = @($property.where({$_ -notin $excludeProperty}))
            $customProperty = @()
            
            $SourceData |
            Select-Object -ExcludeProperty $excludeProperty -Property @($property; $customProperty) |
            ConvertTo-DbaDataTable |
            Write-DbaDataTable @dbiParams @dTParams
        }
    }
}