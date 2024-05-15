function Sync-Retention {
[cmdletbinding(SupportsShouldProcess)]

param(
    [Parameter(Mandatory)]
    [ValidateSet('Tags','Policies')]
    [string[]]$Operation,
    $OPRP = @(Get-OPRetentionPolicy),
    $OPRT = @(Get-OPRetentionPolicyTag),
    $OLRP = @(Get-RetentionPolicy),
    $OLRT = @(Get-RetentionPolicyTag)
)

    Switch ($Operation)
    {
        'Tags'
        {
            $OPRTHT = $OPRT | Group-Object -AsHashTable -property Name
            $OLRTHT = $OLRT | Group-Object -AsHashTable -property Name

            # Identify the Tags in use in Policies on premises
            $OPRTIU = @($OPRT.where({$_.Name -In $OPRP.RetentionPolicyTagLinks}))
            $OPOLRTMatchedByName = @($OLRT.where({$_.name -in $OPRTIU.name}))
            $OPOLRTNotMatchedByName = @($OPRTIU.where({$_.name -notin $OLRT.name}))

            # Tag Properties to ignore when comparing
            $TagCompareProperties = @(
                'Name'
                'AgeLimitForRetention'
                'Comment'
                'LocalizedComment'
                'LocalizedRetentionPolicyTagName'
                'MessageClass'
                'MustDisplayCommentEnabled'
                'RetentionAction'
                'RetentionEnabled'
                'RetentionID'
                'SystemTag'
                'Type'
            )

            #validate and update matched Retention Tags
            foreach ($t in $OPOLRTMatchedByName) {
                Write-Information -MessageData "Processing Retention Tag '$($t.Name)'"
                $CCOTParams = @{
                    ReferenceObject = $OPRTHT.$($t.name) | Select-Object -Property $TagCompareProperties
                    DifferenceObject = $t | Select-Object -Property $TagCompareProperties
                    Show = 'DifferentOnly'
                }
                $Differences = @(Compare-ComplexObject @CCOTParams)

                switch ($Differences.count)
                {
                    0
                    {
                        Write-Information -MessageData "No Differences Identified for Tag '$($t.Name)'"
                    }
                    {
                        $_ -ge 1
                    }
                    {
                        Write-Information -MessageData "Differences Identified: $($Differences.Property -join ';')"
                        $SetRPTParams = @{
                            Identity = $t.guid
                        }
                        Foreach ($d in $Differences)
                        {
                            $SetRPTParams.$($d.Property) = $OPRTHT.$($t.name).$($d.property)
                        }
                        if ($PSCmdlet.ShouldProcess($t.name,'Set-RetentionPolicyTag')) {
                            Set-RetentionPolicyTag @SetRPTParams
                        }
                    }
                }
            }

            #create required Retention Tags
            foreach ($t in $OPOLRTNotMatchedByName) {
                Write-Information -MessageData "Processing Retention Tag $($t.Name)"
                $NewRPTParams = @{
                    Name = $t.Name
                    AgeLimitForRetention = $t.AgeLimitForRetention
                    Comment = $t.Comment
                    LocalizedComment = $t.LocalizedComment
                    LocalizedRetentionPolicyTagName = $t.LocalizedRetentionPolicyTagName
                    MessageClass = $t.MessageClass
                    MustDisplayCommentEnabled = $t.MustDisplayCommentEnabled
                    RetentionAction = $t.RetentionAction
                    RetentionEnabled = $t.RetentionEnabled
                    RetentionID = $t.RetentionID
                    SystemTag = $t.SystemTag
                    Type = $t.Type
                }
                if ($PSCmdlet.ShouldProcess($t.name,'New-RetentionPolicyTag')) {
                    New-RetentionPolicyTag @NewRPTParams
                }
            }
        }
        'Policies'
        {
            $OPRPHT = $OPRP | Group-Object -AsHashTable -property Name
            $OLRPHT = $OLRP | Group-Object -AsHashTable -property Name

            #Identify the Policies that exist or don't exist online in relation to on-premises policies
            $OPOLRP_MatchedByName = @($OLRP.where({$OPRPHT.containskey($_.Name)}))
            $OPOLRP_NotMatchedByName = @($OPRP.where({-not $OLRPHT.containskey($_.Name)}))

            $PolicyCompareProperties = @('Name','IsDefault','IsDefaultArbitrationMailbox','RetentionID','RetentionPolicyTagLinks')

            #Validate and update the Matching Policies
            foreach ($p in $OPOLRP_MatchedByName){
                Write-Information -MessageData "Processing Retention Policy '$($p.Name)'"
                $CCOParams = @{
                    ReferenceObject = $OPRPHT.$($p.name) | Select-Object -Property $PolicyCompareProperties
                    DifferenceObject = $p | Select-Object -Property $PolicyCompareProperties
                    Show = 'DifferentOnly'
                }
                $Differences = @(Compare-ComplexObject @CCOParams)
                switch ($Differences.count)
                {
                    0
                    {
                        Write-Information -MessageData "No Differences Identified for Policy '$($p.Name)'"
                    }
                    {
                        $_ -ge 1
                    }
                    {
                        Write-Information -MessageData "Differences Identified: $($Differences.Property -join ';')"
                        $SetRPParams = @{
                            Identity = $p.guid
                        }
                        Foreach ($d in $Differences)
                        {
                            switch ($d.property -like 'IsDefaul*')
                            {
                                $true
                                {
                                    Write-Information -MessageData "Difference in '$($d.property)' detected.  Please review defaults and set manually if required"
                                }
                                $false
                                {$SetRPParams.$($d.Property) = $OPRPHT.$($p.name).$($d.property)}
                            }
                        }
                        if ($PSCmdlet.ShouldProcess($p.name,'Set-RetentionPolicy')) {
                            Set-RetentionPolicy @SetRPParams
                        }
                    }
                }
            }

            #Create the not matching policies
            foreach ($p in $OPOLRP_NotMatchedByName) {
                Write-Information -MessageData "Processing Retention Policy '$($p.Name)'"
                $NewRPParams = @{
                    Name = $p.Name
                    #IsDefault = $p.IsDefault
                    #IsDefaultArbitrationMailbox = $p.IsDefaultArbitrationMailbox
                    RetentionID = $p.RetentionID
                    RetentionPolicyTagLinks = $p.RetentionPolicyTagLinks
                }
                if ($PSCmdlet.ShouldProcess($p.name,'New-RetentionPolicy')) {
                    New-RetentionPolicy @NewRPParams
                }
            }
        }
    }
}