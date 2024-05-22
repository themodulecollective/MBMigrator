function Export-ExchangeRetentionPolicy
{
    <#
    .SYNOPSIS
        Get all existing Compliance Retention Policies (and Rules) from a Tenant and export to an Excel file
    .DESCRIPTION
        Export all Active Directory user to an XML file. Optional Zip export using $compressoutput switch param. Can specify additional properties to be included in the user export using CustomProperty param.
    .EXAMPLE
        Export-ComplianceRetentionPolicy -OutputFolderPath "C:\Users\UserName\Documents"
        All Compliance Retention Policies in the connected tenant will be exported to a date stamped file with a name like RetentionPoliciesAsOfyyyyMMddhhmmss.xlsx
    #>

    [cmdletbinding()]
    param(
        # Folder path for the XML or Zip export
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath      
        ,
        # Specify a delimiter, 1 character in length.  Default is '|'.
        [parameter()]
        [ValidateLength(1,1)]
        [string]$Delimiter = '|'
    )

    $PolicyProperties = @(
        'Name'
        'AdminDisplayName'
        @{
            n='GUID';e={$_.Guid.guid}
        }
        @{
            n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}
        }
        @{
            n='RetentionId';e={$_.RetentionId.guid}
        }
        @{
            n='RetentionPolicyTagLinks';e={$($_.RetentionPolicyTagLinks | Sort-Object) -join " $Delimiter "}
        }
        'Identity'
        'IsDefault'
        'IsDefaultArbitrationMailbox'
        'IsValid'
        'ExchangeVersion'
        'WhenChangedUTC'
        'WhenCreatedUTC'
        'OrganizationalUnitRoot'
        'OrganizationId'
        'DistinguishedName'
    )

    $TagProperties = @(
        'Name'
        'AdminDisplayName'
        'Description'
        'Comment'
        @{
            n='GUID';e={$_.Guid.guid}
        }
        @{
            n='ExchangeObjectId';e={$_.ExchangeObjectId.guid}
        }
        @{
            n='RetentionId';e={$_.RetentionId.guid}
        }
        @{
            n='RawRetentionId';e={$_.RawRetentionId.guid}
        }
        'Identity'
        'RetentionEnabled'
        'Type'
        'MessageClass'
        'MessageClassDisplayName'
        'TriggerForRetention'
        'AgeLimitForRetention'
        'RetentionAction'
        'AddressForJournaling'
        'IsDefaultAutoGroupPolicyTag'
        'IsDefaultModeratedRecipientsPolicyTag'
        'IsPrimary'
        'IsValid'
        'JournalingEnabled'
        'LabelForJournaling'
        'LegacyManagedFolder'
        @{
            n='LocalizedComment';e={$_.LocalizedComment -join " $Delimiter "}
        }
        @{
            n='LocalizedRetentionPolicyTagName';e={$_.LocalizedRetentionPolicyTagName -join " $Delimiter "}
        }
        'MessageFormatForJournaling'
        'MoveToDestinationFolder'
        'MustDisplayCommentEnabled'
        'SystemTag'
        'ExchangeVersion'
        'WhenChangedUTC'
        'WhenCreatedUTC'
        'OrganizationalUnitRoot'
        'OrganizationId'
        'DistinguishedName'
    )

    $DateString = Get-Date -Format yyyyMMddhhmmss

    $OutputFileName = 'ExchangeRetentionPolicies' + 'AsOf' + $DateString
    $OutputFilePath = Join-Path -Path $OutputFolderPath -ChildPath $($OutputFileName + '.xlsx')

    $Policies = Get-RetentionPolicy | Select-Object -property $PolicyProperties
    $Tags = Get-RetentionPolicyTag | Select-Object -property $TagProperties

    $Policies | Export-Excel -Path $OutputFilePath -WorksheetName 'Policies' -tablename 'Policies' -tablestyle Medium11
    $Tags | Export-Excel -Path $OutputFilePath -WorksheetName 'Tags' -tablename 'Tags' -tablestyle Medium11

}