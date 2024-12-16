[cmdletbinding()]
param(
    [parameter()]
    [validateset('Full', 'WaveRelated', 'VolatileFields', 'NonVolatileFields', 'CustomFields', 'MigrationStatus')]
    [string]$FieldSet
    ,
    [parameter()]
    [ValidateSet('1-UpdateDatabaseWithSharePointItemIDs', '2-UpdateDatabaseExceptions', '3-UpdateDatabaseItems')]
    [string[]]$DatabaseOperation
    ,
    [parameter()]
    [ValidateSet('4-AddSharePointItems', '5-UpdateSharePointItems')]
    [string[]]$SharePointOperation
    ,
    [switch]$TestSharePointResult
    ,
    [parameter()]
    [ValidateSet(
        'SourceEntraID',
        'TargetEntraID',
        'SourceADID',
        'TargetADID',
        'SourceConsistency',
        'TargetConsistency',
        'WDEmployeeID',
        'SourceEntraIDEnabled',
        'TargetEntraIDEnabled',
        'SourceADEnabled',
        'TargetADEnabled',
        'LeaveStatus',
        'SourceCanonicalName',
        'TargetCanonicalName',
        'SourceFirstName',
        'TargetFirstName',
        'SourceLastName',
        'TargetLastName',
        'SourceDisplayName',
        'TargetDisplayName',
        'SourceMail',
        'TargetMail',
        'SourceRecipientType',
        'TargetRecipientType',
        'SourceTargetAddress',
        'TargetTargetAddress',
        'SourceForwardingSMTPAddress',
        'TargetForwardingSMTPAddress',
        'SourceAlias',
        'TargetAlias',
        'SourceSAM',
        'TargetSAM',
        'SourceADUPN',
        'TargetADUPN',
        'SourceEntraUPN',
        'TargetEntraUPN',
        'TargetGuestUPN',
        'SpecialHandlingNotes',
        'SourceLitigationHoldEnabled',
        'TargetLitigationHoldEnabled',
        'SourceDriveURL',
        'TargetDriveURL',
        'WorkFolders',
        'usageLocation',
        'Country',
        'Location',
        'LocationCountry',
        'Region',
        'SourceLicensing',
        'TargetLicensing',
        'SourceMobileDevices',
        'msExchExtensionAttribute16',
        'msExchExtensionAttribute17',
        'msExchExtensionAttribute18',
        'msExchExtensionAttribute20',
        'msExchExtensionAttribute21',
        'msExchExtensionAttribute22',
        'SourceEntraType',
        'TargetEntraType',
        'SourceADDomain',
        'TargetADDomain',
        'SourceDC',
        'TargetDC',
        'MatchScenario',
        'AssignedWave',
        'AssignmentType',
        'TargetDate',
        'ManagerEmail',
        'SourceMailboxGB',
        'SourceMailboxItemCount',
        'SourceDriveGB',
        'SourceDriveCount',
        'SourceEntraLastSyncTime',
        'TargetEntraLastSyncTime',
        'SourceEntraLastSigninTime',
        'TargetEntraLastSigninTime',
        'SourceMFARegistered',
        'TargetMFARegistered'
    )]
    [string[]]$CustomFields
    ,
    [string]$DatabaseListUpdateQueryFile = 'MigrationListDraft.sql'
)

# Sort Operation for proper order
$DatabaseOperation = @($DatabaseOperation | Sort-Object)
$SharePointOperation = @($SharePointOperation | Sort-Object)

# fields to process for compare operations
Write-Log -Level INFO -Message "Starting list synchronization between Database and SharePoint"
$SQLStableFields = @(
    'SourceEntraID'
    'TargetEntraID'
    'SourceADID'
    'TargetADID'
    'SourceConsistency'
    'TargetConsistency'
    'WDEmployeeID'
    'SourceEntraIDEnabled'
    'TargetEntraIDEnabled'
    'SourceADEnabled'
    'TargetADEnabled'
    'LeaveStatus'
    'SourceCanonicalName'
    'TargetCanonicalName'
    'SourceFirstName'
    'TargetFirstName'
    'SourceLastName'
    'TargetLastName'
    'SourceDisplayName'
    'TargetDisplayName'
    'SourceMail'
    'TargetMail'
    'TargetRewriteAddress'
    'SourceRecipientType'
    'TargetRecipientType'
    'SourceTargetAddress'
    'TargetTargetAddress'
    'SourceForwardingSMTPAddress'
    'TargetForwardingSMTPAddress'
    'SourceAlias'
    'TargetAlias'
    'SourceSAM'
    'TargetSAM'
    'SourceADUPN'
    'TargetADUPN'
    'SourceEntraUPN'
    'TargetEntraUPN'
    'TargetGuestUPN'
    'SpecialHandlingNotes'
    'SourceLitigationHoldEnabled'
    'TargetLitigationHoldEnabled'
    'SourceDriveURL'
    'TargetDriveURL'
    'WorkFolders'
    'usageLocation'
    'Country'
    'Location'
    'LocationCountry'
    'Region'
    'SourceLicensing'
    'TargetLicensing'
    'SourceMobileDevices'
    'msExchExtensionAttribute16'
    'msExchExtensionAttribute17'
    'msExchExtensionAttribute18'
    'msExchExtensionAttribute20'
    'msExchExtensionAttribute21'
    'msExchExtensionAttribute22'
    'SourceEntraType'
    'TargetEntraType'
    'SourceADDomain'
    'TargetADDomain'
    'SourceDC'
    'TargetDC'
    'MatchScenario'
    'AssignedWave'
    'AssignmentType'
    'TargetDate'
    'ManagerEmail'
    'SourceMFARegistered'
    'TargetMFARegistered'
    'FlyOneDrive'
    'FlyTeamsChat'
    'FlyExchange'
)
$SQLVolStatsFields = @(
    'SourceMailboxGB'
    'SourceMailboxDeletedGB'
    'SourceMailboxItemCount'
    'SourceDriveGB'
    'SourceDriveCount'
)
$SQLVolDatesFields = @(
    'SourceEntraLastSyncTime'
    'TargetEntraLastSyncTime'
    'SourceEntraLastSigninTime'
    'TargetEntraLastSigninTime'
    'SourcePasswordLastSet'
    'TargetPasswordLastSet'
    'TargetGoodForKerb'
)
$spoMasterFields = @('MigrationStatus')
$SQLID = @('spoitemid')
$SPOID = @('ID')

$NonIDFields = @($SQLStableFields; $SQLVolStatsFields; $SQLVolDatesFields)
$SQLFields = @($NonIDFields; $SQLID)
$SPOFields = @($NonIDFields; $SPOID; $spoMasterFields)
#$nonURLFields = @($allFields).where({$_ -notin $URLFields})

$FieldsToProcessForSPO = @(switch ($FieldSet)
    {
        'Full'
        {
            $NonIDFields
        }
        'WaveRelated'
        {
            'AssignedWave', 'AssignmentType', 'SpecialHandlingNotes', 'TargetDate', 'FlyOneDrive', 'FlyTeamsChat', 'FlyExchange'
        }
        'VolatileFields'
        {
            $SQLVolStatsFields; $SQLVolDatesFields
        }
        'NonVolatileFields'
        {
            $SQLStableFields
        }
        'CustomFields'
        {
            $CustomFields
        }
        'MigrationStatus'
        {
            'MigrationStatus'
        }
    })
$FieldsToProcessForSPO = @($($FieldsToProcessForSPO; 'SourceEntraID', 'SourceADID', 'ID') | Sort-Object -Unique | Select-Object -Unique)
Write-Log -Level INFO -Message "Fields that will be processed if updating SharePoint Migration List:  $($FieldsToProcessForSPO -join ' | ')"

$SiteListParams = @{
    SiteId = $MBMConfiguration.WavePlanningSiteID
    ListID = $MBMConfiguration.UserMigrationListID
}

# get the Special Handling entries from SPO List and update SQL
Write-Log -Level INFO -Message "Running: Getting SharePoint Special Handling Entries and Updating Database"
$SpecialHandlingListID = '652ebd84-a5ab-46a7-b611-65e58b9f20ad'
#$SpecialHandling = Get-OGSiteListItem -SiteId $SiteListParams.SiteId -ListId $SpecialHandlingListID -Column EmailAddress,WDEmployeeID,Note
$SpecialHandlingRawSPO = Get-PnPListItem -List $SpecialHandlingListID -Fields 'EmailAddress', 'EmailAddress_x003a__x0020_WDEmpl', 'LinkTitle'
$SpecialHandlingRawObjects = @($SpecialHandlingRawSPO.foreach({ [pscustomobject][hashtable]$($_.FieldValues) }))
Write-Log -Level INFO -Message "Found $($SpecialHandlingRawObjects.count) SharePoint Special Handling Entries"
$SpecialHandlingRawObjects |
Select-Object -Property @{n = 'SourceMail'; e = { $_.EmailAddress.LookupValue } }, @{n = 'EmployeeID'; e = { $_.EmailAddress_x003a__x0020_WDEmpl.LookupValue } }, @{n = 'Note'; e = { $_.Title } } |
ConvertTo-DbaDataTable |
Write-DbaDataTable @idbParams -Table stagingSpecialHandling -AutoCreateTable -Truncate
Write-Log -Level INFO -Message "Completed: Getting SharePoint Special Handling Entries and Updating Database"

# get the wave plan from the SPO List and update SQL
Write-Log -Level INFO -Message "Running: Getting SharePoint Wave Plan and Updating Database"
$WavePlanListID = '74befe9a-4850-4e3f-90bf-01e1b80b8155'
#$wavePlan = Get-OGSiteListItem -SiteId $SiteListParams.SiteId -ListId $WavePlanListID -Column Title,Description,TargetDate,T1
$wavePlanpnp = Get-PnPListItem -List $WavePlanListID -Fields Title, TargetDate, T1, FlyOneDrive, FlyTeamsChat, FlyExchange, Description
$waveplanObjects = $wavePlanpnp.foreach({ [PSCustomObject][hashtable]$($_.FieldValues) })
$wavePlanObjects | Select-object -Property @{n = 'Wave'; e = { $_.Title } }, TargetDate, T1, FlyOneDrive, FlyTeamsChat, FlyExchange, Description | ConvertTo-DbaDataTable | Write-DbaDataTable -Table stagingWavePlan @idbParams -truncate
Write-Log -Level INFO -Message "Completed: Getting SharePoint Wave Plan and Updating Database"

# get all the items from the SPO list
Write-Log -Level INFO -Message "Running: Getting SharePoint Migration List Items"
$PNPListItems = @(Get-pnplistitem -List $SiteListParams.ListID -Fields $SPOFields -PageSize 1000)
$RawSPOObjects = @($PNPListItems.foreach({ [PSCustomObject][hashtable]$($_.FieldValues) }))
$SPOListItems = $RawSPOObjects | Select-Object -Property $SPOFields
Write-Log -Level INFO -Message "$($SPOListItems.count) items retrieved from SharePoint Migration List"
Write-Log -Level INFO -Message "Completed: Getting SharePoint Migration List Items"

switch ($DatabaseOperation)
{

    '1-UpdateDatabaseWithSharePointItemIDs'
    {
        # Update the SQL Database IDs for the SPO List Items
        Write-Log -Level INFO -Message "Updating Database with SPO Item IDs and Migration Status"
        $SPOListItems |
        Select-Object -Property id, SourceEntraID, SourceADID, MigrationStatus |
        ConvertTo-DbaDataTable |
        Write-DbaDataTable @idbParams -table 'stagingSPOUserMigrationListIDs' -Truncate
    }
    '2-UpdateDatabaseExceptions'
    {
        # Find new Wave Exceptions from SPO
        try
        {
            Write-Log -Level INFO -Message "Running: Retrieve Database Wave Exceptions"
            $SQLWaveExceptions = Invoke-DbaQuery @idbParams -Query 'SELECT SourceEntraID,SourceMail,AssignedWave FROM WaveExceptions' -as PSObject -ErrorAction Stop
            Write-Log -Level INFO -Message "Completed: Retrieve Database Wave Exceptions"
            Write-Log -Level INFO -Message "$($SQLWaveExceptions.count) Wave Exceptions Retrieved from Database"
        }
        catch
        {
            Write-Log -Level INFO -Message "Failed: Retrieve Database Wave Exceptions"
            throw("Database Wave Exceptions Not Found")
        }
        Write-Log -Level INFO -Message "Running:  Find SharePoint Wave Exceptions"
        $SPOWaveExceptions = $SPOListItems.where({ $_.AssignmentType -eq 'ByException' }) | Select-Object -Property SourceEntraID, SourceMail, AssignedWave
        Write-Log -Level INFO -Message "Completed:  Find SharePoint Wave Exceptions"
        Write-Log -Level INFO -Message "$($SPOWaveExceptions.count) Wave Exceptions Retrieved from SharePoint"
        Write-Log -Level INFO -Message "Running: Compare Database and SharePoint Wave Exceptions to find New Exceptions"
        $SQLWaveExceptionsHash = @{}
        $SQLWaveExceptions.foreach({ $SQLWaveExceptionsHash.add($_.SourceEntraID, $_) })
        $addExceptions = @($SPOWaveExceptions.where({ -not $SQLWaveExceptionsHash.ContainsKey($_.SourceEntraID) }))
        Write-Log -Level INFO -Message "Completed: Compare Database and SharePoint Wave Exceptions to find New Exceptions"
        Write-Log -Level INFO -Message "$($addExceptions.count) new SharePoint Wave Exceptions Found."

        if ($addExceptions.count -ge 1)
        {
            Write-Log -Level INFO -Message "Running: Adding $($addExceptions.count) new SharePoint Wave Exceptions to Database Wave Exceptions"
            $addExceptions | ConvertTo-DbaDataTable | Write-DbaDataTable @idbParams -Table WaveExceptions
            Write-Log -Level INFO -Message "Completed: Adding $($addExceptions.count) new SharePoint Wave Exceptions to Database Wave Exceptions"
        }
        Write-Log -Level INFO -Message "Running: Compare and Update Existing Exceptions (SharePoint overwrites Database)"
        $ExceptionDifferenceItems = @(
            $SPOWaveExceptions.where({ $SQLWaveExceptionsHash.ContainsKey($_.SourceEntraID) }).foreach({
                $SPOitem = $_
                $SQLItem = $SQLWaveExceptionsHash.$($SPOitem.SourceEntraID)
                if ($SQLItem.AssignedWave -ne $SPOitem.AssignedWave)
                {
                    Write-Log -Level INFO -Message "Found Difference Exception for moving $($SQLitem.SourceEntraID) from $($SQLItem.AssignedWave) to AssignedWave $($SPOitem.AssignedWave)"
                    $SPOitem
                }
            })
        )
        Write-Log -Level INFO -Message "Found $($ExceptionDifferenceItems.count) Exception Items to Update in Database"
        Write-Log -Level INFO -Message "Running: Update Database Exception Items"
        $ExceptionDifferenceItems.foreach({
            $SPOItem = $_
            $query = "UPDATE WaveExceptions SET AssignedWave = $($SPOitem.AssignedWave) WHERE SourceEntraID = '$($SPOitem.SourceEntraID)'"
            try {
                Invoke-DbaQuery @idbParams -Query $query -ErrorAction stop
            }
            catch {
                Write-Log -Level WARNING -Message "Failed to Update item with query: $query"
            }
        })
        Write-Log -Level INFO -Message "Completed: Update Database Exception Items"
        Write-Log -Level INFO -Message "Completed: Compare and Update Existing Exceptions (SharePoint overwrites Database)"
    }
    '3-UpdateDatabaseItems'
    {
        try
        {
            Write-Log -Level INFO -Message "Updating SQL MigrationList"
            Invoke-DbaQuery @idbParams -File $DatabaseListUpdateQueryFile -ErrorAction Stop
        }
        catch
        {
            Throw($_)
        }
    }
}

Write-Log -Level INFO -Message "Running: Getting Database Migration List Items"
$MigrationList = Get-MBMMigrationList
Write-Log -Level INFO -Message "$($MigrationList.count) items retrieved from Database Migration List"
Write-Log -Level INFO -Message "Completed: Getting Database Migration List Items"

switch ($SharePointOperation)
{
    '4-AddSharePointItems'
    {
        Write-Log -Level INFO -Message "Running: Finding New Database Items (not yet in SharePoint Migration List)"
        # Migration List Items to Add to SPO List
        $AddItems = $MigrationList.where({ [string]::IsNullOrEmpty($_.SPOitemID) })
        Write-Log -Level INFO -Message "$($AddItems.count) new items found for SharePoint Migration List"
        Write-Log -Level INFO -Message "Completed: Finding New Database Items (not yet in SharePoint Migration List)"
        switch ($TestSharePointResult)
        {
            $true
            {
                $Global:ReviewAddItems = $AddItems
                Write-Log -Level INFO -Message "TestSharePointResult was specified.  Review the ReviewAddItems data to verify test."
            }
            Default
            {
                Write-Log -Level INFO -Message "Running: Add New Database Items to SharePoint Migration List"
                $AddErrors = [System.Collections.Generic.List[psobject]]::new()
                $AddPnpListBatch = New-PnPBatch
                $AddItems.foreach({
                        $hash = [ordered]@{}
                        $i = $_
                        $NonIDFields.foreach({
                                $hash.add($_, $i.$($_))
                            })
                        try
                        {
                            Write-Log -Message "Adding Item with $($hash.Keys.Count) Attributes $($hash.Keys -join ' | ')" -Level INFO
                            #$null = New-OGSiteListItem @SiteListParams -Fields $hash -RemoveNullField -ErrorAction Stop
                            $null = Add-PnPListItem -List $SiteListParams.ListID -Values $hash -ErrorAction Stop -Batch $AddPnpListBatch
                        }
                        catch
                        {
                            $AddErrors.add($_)
                        }

                    })
                Write-Log -Message "Processing Batch of $($addpnplistbatch.RequestCount) Adds to SharePoint Migration List" -Level INFO
                Invoke-PnPBatch -Batch $AddPnpListBatch -Details
                Write-Log -Level INFO -Message "Running: Add New Database Items to SharePoint Migration List"

            }
        }
    }
    '5-UpdateSharePointItems'
    {
        # setup to find diffs for the spo list updates
        $spoListItemsHash = @{}
        $SPOListItems.foreach({ $spoListItemsHash.add($_.id, $_) })
        if ($FieldSet -eq 'MigrationStatus')
        {
            $MigrationStatuses = Invoke-DbaQuery @idbParams -Query 'SELECT spoitemid,MigrationStatus FROM vMigrationStatusPerUser' -as PSObject -ErrorAction Stop
        }
        $UpdateCount = 0
        switch ($TestSharePointResult)
        {
            $true
            {
                $TestResults = [System.Collections.Generic.List[psobject]]::new()
            }
            Default
            {
                $UpdateErrors = [System.Collections.Generic.List[psobject]]::new()
                $SetPNPListBatch = New-PnPBatch
            }
        }
        Write-Log -Level INFO -Message "Running: Processing Comparison of existing Database and SharePoint Migration List Items for the specified FieldSet: $FieldSet"
        Switch ($FieldSet)
        {
            'MigrationStatus'
            {
                $MigrationStatuses.foreach({
                        $item = $_
                        $spoItem = $spoListItemsHash.$($item.spoitemid) | Select-Object -Property ID, MigrationStatus
                        $itemID = $item.spoitemid
                        $Differences = @(Compare-ComplexObject -ReferenceObject $spoItem -DifferenceObject $item -Show DifferentOnly -SuppressedProperties ID, spoitemid)
                        if ($Differences.count -ge 1)
                        {
                            #update SPO List Item
                            $SPOvalues = @{}
                            $Differences.where({ $_.Property -in $FieldsToProcessForSPO }).foreach({
                                    $SPOvalues.add($_.Property, $_.DifferenceObjectValue[0])
                                })
                            try
                            {
                                if ($SPOvalues.Keys.count -ge 1)
                                {
                                    Write-Log -Message "Sending Changes to $($SPOvalues.Keys.Count) Attributes $($SPOvalues.Keys -join ' | ') for Entry $ItemId" -Level INFO
                                    switch ($TestSharePointResult)
                                    {
                                        $true
                                        {
                                            #Write-Log -Message "Running: TestResults for $($SPOvalues.Keys.Count) Attributes ($($SPOvalues.Keys -join ' | ')) for Entry $itemID" -Level INFO
                                            $SPOvalues.add('SpoItemID',$itemID)
                                            $TestResults.add($SPOvalues)
                                        }
                                        Default
                                        {
                                            #Write-Log -Message "Running: Set-PNPListItem Batch for $($SPOvalues.Keys.Count) Attributes ($($SPOvalues.Keys -join ' | ')) for Entry $itemID" -Level INFO
                                            Set-PnPListItem -List $MBMConfiguration.UserMigrationListID -Identity $itemID -Values $SPOvalues -Verbose -ErrorAction Stop -Batch $SetPNPListBatch
                                            #Write-Log -Message "Completed: Set-PNPListItem Batch for $($SPOvalues.Keys.Count) Attributes for Entry $itemID" -Level INFO
                                        }
                                    }
                                    $UpdateCount++
                                }
                                else
                                {
                                    #Write-Log -Message "No Changes Identified for Entry $($spoItem.id)" -Level INFO
                                }
                            }
                            catch
                            {
                                $UpdateErrors.Add($_)
                            }
                        }
                    })
            }
            Default
            {
                $MigrationList.where({ -not [string]::IsNullOrEmpty($_.spoitemid) }).foreach({
                        $item = $_
                        $spoItem = $spoListItemsHash.$($item.spoitemid)
                        $itemID = $item.spoitemid
                        $ItemCustomProperties = @(
                            @{n = 'SourceEntraLastSyncTime'; e = { if ($null -eq $item.SourceEntraLastSyncTime) { $null } else { Get-Date -date $item.SourceEntraLastSyncTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'TargetEntraLastSyncTime'; e = { if ($null -eq $item.TargetEntraLastSyncTime) { $null } else { Get-Date -date $item.TargetEntraLastSyncTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'SourceEntraLastSigninTime'; e = { if ($null -eq $item.SourceEntraLastSigninTime) { $null } else { Get-Date -date $item.SourceEntraLastSigninTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'TargetEntraLastSigninTime'; e = { if ($null -eq $item.TargetEntraLastSigninTime) { $null } else { Get-Date -date $item.TargetEntraLastSigninTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'TargetDate'; e = { if ($null -eq $item.TargetDate) { $null } else { Get-Date -date $item.TargetDate -hour 12 -Minute 0 -Second 0 } } }
                            @{n = 'SourcePasswordLastSet'; e = { if ($null -eq $item.SourcePasswordLastSet) { $null } else { Get-Date -date $item.SourcePasswordLastSet -hour 12 -Minute 0 -Second 0 } } }
                            @{n = 'TargetPasswordLastSet'; e = { if ($null -eq $item.TargetPasswordLastSet) { $null } else { Get-Date -date $item.TargetPasswordLastSet -hour 12 -Minute 0 -Second 0 } } }
                        )
                        $item = $item | Select-Object -ExcludeProperty $ItemCustomProperties.n -Property @('*'; $ItemCustomProperties)
                        $spoItemCustomProperties = @(
                            @{n = 'SourceEntraLastSyncTime'; e = { if ($null -eq $spoItem.SourceEntraLastSyncTime) { $null } else { Get-Date -date $spoItem.SourceEntraLastSyncTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'TargetEntraLastSyncTime'; e = { if ($null -eq $spoItem.TargetEntraLastSyncTime) { $null } else { Get-Date -date $spoItem.TargetEntraLastSyncTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'SourceEntraLastSigninTime'; e = { if ($null -eq $spoItem.SourceEntraLastSigninTime) { $null } else { Get-Date -date $spoItem.SourceEntraLastSigninTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'TargetEntraLastSigninTime'; e = { if ($null -eq $spoItem.TargetEntraLastSigninTime) { $null } else { Get-Date -date $spoItem.TargetEntraLastSigninTime -hour 0 -Minute 0 -Second 0 } } }
                            @{n = 'SourcePasswordLastSet'; e = { if ($null -eq $spoItem.SourcePasswordLastSet) { $null } else { Get-Date -date $spoItem.SourcePasswordLastSet -hour 12 -Minute 0 -Second 0 } } }
                            @{n = 'TargetPasswordLastSet'; e = { if ($null -eq $spoItem.TargetPasswordLastSet) { $null } else { Get-Date -date $spoItem.TargetPasswordLastSet -hour 12 -Minute 0 -Second 0 } } }
                        )
                        $spoItem = $spoItem | Select-Object -ExcludeProperty $spoItemCustomProperties.n -Property @('*'; $spoItemCustomProperties)

                        $Differences = @(Compare-ComplexObject -ReferenceObject $spoItem -DifferenceObject $item -Show DifferentOnly -SuppressedProperties ID, spoitemid)
                        if ($Differences.count -ge 1)
                        {
                            #update SPO List Item
                            $SPOvalues = @{}
                            $Differences.where({ $_.Property -in $FieldsToProcessForSPO }).foreach({
                                    $SPOvalues.add($_.Property, $_.DifferenceObjectValue[0])
                                })
                            try
                            {
                                if ($SPOvalues.Keys.count -ge 1)
                                {
                                    switch ($TestSharePointResult)
                                    {
                                        $true
                                        {

                                            #Write-Log -Message "Running: TestResults for $($SPOvalues.Keys.Count) Attributes ($($SPOvalues.Keys -join ' | ')) for Entry $itemID" -Level INFO
                                            $TestResults.add($SPOvalues)
                                        }
                                        Default
                                        {
                                            #Write-Log -Message "Running: Set-PNPListItem Batch for $($SPOvalues.Keys.Count) Attributes ($($SPOvalues.Keys -join ' | ')) for Entry $itemID" -Level INFO
                                            Set-PnPListItem -List $MBMConfiguration.UserMigrationListID -Identity $itemID -Values $SPOvalues -Verbose -ErrorAction Stop -Batch $SetPNPListBatch
                                            #Write-Log -Message "Completed: Set-PNPListItem Batch for $($SPOvalues.Keys.Count) Attributes for Entry $itemID" -Level INFO
                                        }
                                    }
                                    $UpdateCount++
                                }
                            }
                            catch
                            {
                                Write-Log -Level WARNING -Message "Update for Entry $itemID Generated an error"
                                Write-Log -Message "Attempted Update: Set-PNPListItem Batch for $($SPOvalues.Keys.Count) Attributes ($($SPOvalues.Keys -join ' | ')) for Entry $itemID" -Level INFO
                                Write-Log -Level WARNING -Message $_.ToString()
                                $UpdateErrors.Add($_)
                            }
                        }
                    })
            }
        }
        switch ($TestSharePointResult)
        {
            $true
            {
                Write-Log -Message "Generated $($TestResults.count) SharePoint Migration List Update Test Values"
                $Global:ReviewUpdateItems = @($TestResults)
                Write-Log -Level INFO -Message "TestSharePointResult was specified.  Review the ReviewUpdateItems data to verify test."
            }
            Default
            {
                Write-Log -Message "Processing Update Batch for $UpdateCount SharePoint Migration List Items" -Level INFO
                Invoke-PnPBatch -Batch $SetPNPListBatch -Details
                Write-Log -Message "Completed Update Batch for $UpdateCount SharePoint Migration List Items" -Level INFO
            }
        }
    }
}









