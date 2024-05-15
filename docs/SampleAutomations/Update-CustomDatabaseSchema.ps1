function Update-CustomDatabaseSchema
{
    [cmdletbinding()]
    param(
        [switch]$AddIndexes
    )
    $Configuration = Get-MBMConfiguration -Default

    $dbParams = @{
        SQLInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    $existingDatabase = Get-DbaDatabase @dbParams

    if ($null -ne $existingDatabase -and $existingDatabase -is [Microsoft.SqlServer.Management.Smo.Database])
    {

        <# add back in later if table names need updated
        $eSQL = $ExecutionContext.InvokeCommand.ExpandString($SQLScripts.renameTables)
        Invoke-DbaQuery @dbparams -query $eSQL
        #>

        $existingTables = Get-DbaDbTable @dbParams | Select-Object -ExpandProperty Name

        $tables = @(
            'PersonDetails'
            'ManagerAssistant'
        )
        # Table Creations
        foreach ($t in $tables.where({$_ -notin $existingTables}))
        {
            Write-Verbose -Message "Creating Table $t on Database $($dbParams.Database)"
            $tableParams = @{}
            $tableParams.name = $t
            $tableParams.columnMap = Get-CustomColumnMap -TableType $tableParams.name
            $null = New-DbaDbTable @dbParams @tableParams
        }

        #View Create/Replace
        <#         $viewScripts = @(
            'DropViews'
            'viewSourceRolesWithMap'
            'viewTargetRolesMatchingSourceRoles'
            'viewStagingDistributionGroupRoleSourceOnly'
            'viewStagingDistributionGroupRoleTargetOnly'
            'viewTargetGroupNotMappedToSource'
        )
        foreach ($s in $viewScripts)
        {
            Write-PSFMessage -Message "Processing SQL Script $s"
            #expand the SQL for any PS Variables/Scriptblocks contained
            $eSQL = $ExecutionContext.InvokeCommand.ExpandString($SQLScripts.$s)
            #set the expanded SQL as the query value
            Write-PSFMessage -Message "Expanded SQL = $eSQL"
            $dbParams.query = $eSQL
            #run the Query
            Invoke-DbaQuery @dbParams -MessagesToOutput -as PSObject
        }
#>

        #add indexes
        <#         if ($AddIndexes)
        {
            $eSQL = $ExecutionContext.InvokeCommand.ExpandString($SQLScripts.Indexes)
            $dbParams.query = $eSQL
            Invoke-DbaQuery @dbparams
        }
#>
    }
}