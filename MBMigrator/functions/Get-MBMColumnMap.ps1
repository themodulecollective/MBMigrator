function Get-MBMColumnMap
{
    <#
    .SYNOPSIS
        Gets a table's column map
    .DESCRIPTION
        Specify a database's table and return the column map for that table
    .EXAMPLE
        Get-MBMColumnMap -TableType ConfigurationOrganization
        Returns the column map for the ConfigurationOrganization table
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [ValidateSet(
            'historyContact',
            'historyMailbox',
            'historyMailboxStats',
            'historyPermissions',
            'historyRecipient',
            'historyADUser',
            'stagingContact',
            'stagingMailbox',
            'stagingMailboxStats',
            'stagingPermissions',
            'stagingRecipient',
            'stagingADUser',
            'configurationOrganization'
        )]
        $TableType
    )

    $ParentTypesToTableTypes = @{
        'historyContact'            = 'Contact'
        'stagingContact'            = 'Contact'
        'stagingRecipient'          = 'Recipient'
        'historyRecipient'          = 'Recipient'
        'stagingADUser'             = 'ADUser'
        'historyADUser'             = 'ADUser'
        'stagingMailbox'            = 'Mailbox'
        'historyMailbox'            = 'Mailbox'
        'stagingMailboxStats'       = 'MailboxStats'
        'historyMailboxStats'       = 'MailboxStats'
        'stagingPermissions'        = 'Permissions'
        'historyPermissions'        = 'Permissions'
        'configurationOrganization' = 'configurationOrganization'
    }

    $ParentType = $ParentTypesToTableTypes.$TableType

    if ($TableType -notin @('configurationOrganization','stagingADUser','historyADUser'))
    {
        @{
            Name      = 'SourceOrganization'
            Type      = 'nvarchar'
            MaxLength = 64
            Nullable  = $true
        }
    }

    switch ($ParentType)
    {
        'Recipient'
        {
            @(
                $(@('ExchangeGuid', 'ExchangeObjectId', 'ExternalDirectoryObjectID', 'ArchiveGuid','Guid').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))
                @{
                    Name      = 'Alias'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'DisplayName'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'PrimarySmtpAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ExternalEmailAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RecipientType'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RecipientTypeDetails'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                $(@(1..15).foreach(
                        {
                            @{
                                Name      = "CustomAttribute$($_)"
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        })
                )
                $(@(1..5).foreach(
                        {
                            @{
                                Name      = "ExtensionCustomAttribute$($_)"
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        })
                )
                @{
                    Name      = 'Department'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'Company'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'Office'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'City'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'DistinguishedName'
                    Type      = 'nvarchar'
                    MaxLength = 1024
                    Nullable  = $true
                }
                @{
                    Name      = 'Manager'
                    Type      = 'nvarchar'
                    MaxLength = 1024
                    Nullable  = $true
                }
                @{
                    Name     = 'WhenCreatedUTC'
                    Type     = 'DateTime'
                    Nullable = $true
                }
                @{
                    Name     = 'WhenChangedUTC'
                    Type     = 'DateTime'
                    Nullable = $true
                }
                @{
                    Name      = 'EmailAddresses'
                    Type      = 'nvarchar'
                    MaxLength = 4000
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveStatus'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveState'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
            )
        }
        'Mailbox'
        {
            @(
                $(@('ExchangeGuid', 'ExchangeObjectId', 'ExternalDirectoryObjectID', 'ArchiveGuid','Guid').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))
                @{
                    Name      = 'Alias'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'SamAccountName'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'DisplayName'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'Name'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'PrimarySmtpAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'UserPrincipalName'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RemoteRoutingAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'TargetAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ForwardingAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ForwardingSmtpAddress'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'LegacyExchangeDN'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RecipientType'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RecipientTypeDetails'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RemoteRecipientType'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'LinkedMasterAccount'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                $(@(1..15).foreach(
                        {
                            @{
                                Name      = "CustomAttribute$($_)"
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        })
                )
                $(@(1..5).foreach(
                        {
                            @{
                                Name      = "ExtensionCustomAttribute$($_)"
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        })
                )
                                @{
                    Name      = 'Department'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'Office'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'OrganizationalUnit'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'Database'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveName'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveDomain'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveStatus'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'ArchiveState'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RetentionPolicy'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RetainDeletedItemsFor'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'ManagedFolderMailboxPolicy'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'AddressBookPolicy'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RoleAssignmentPolicy'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'SharingPolicy'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'DefaultPublicFolderMailbox'
                    Type      = 'nvarchar'
                    MaxLength = 256
                    Nullable  = $true
                }
                @{
                    Name      = 'RecipientLimits'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'ResourceCapacity'
                    Type      = 'nvarchar'
                    MaxLength = 64
                    Nullable  = $true
                }
                @{
                    Name      = 'DistinguishedName'
                    Type      = 'nvarchar'
                    MaxLength = 1024
                    Nullable  = $true
                }
                @{
                    Name     = 'WhenCreatedUTC'
                    Type     = 'DateTime'
                    Nullable = $true
                }
                @{
                    Name     = 'WhenChangedUTC'
                    Type     = 'DateTime'
                    Nullable = $true
                }
                @{
                    Name     = 'WhenMailboxCreated'
                    Type     = 'DateTime'
                    Nullable = $true
                }
                @{
                    Name      = 'EmailAddresses'
                    Type      = 'nvarchar'
                    MaxLength = 4000
                    Nullable  = $true
                }
                @{
                    Name     = 'UseDatabaseRetentionDefaults'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'UseDatabaseQuotaDefaults'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'LitigationHoldEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'SingleItemRecoveryEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'RetentionHoldEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'BccBlocked'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'AutoExpandingArchiveEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'HiddenFromAddressListsEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'EmailAddressPolicyEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'MessageCopyForSentAsEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'MessageCopyForSendOnBehalfEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'DeliverToMailboxAndForward'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'MessageTrackingReadStatusEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'DowngradeHighPriorityMessagesEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'UMEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'IsAuxMailbox'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'CalendarVersionStoreDisabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'SKUAssigned'
                    Type     = 'bit'
                    Nullable = $true
                }
                @{
                    Name     = 'AuditEnabled'
                    Type     = 'bit'
                    Nullable = $true
                }
                $(@('ArchiveQuotaInGB', 'ArchiveWarningQuotaInGB', 'CalendarLoggingQuotaInGB', 'IssueWarningQuotaInGB', 'ProhibitSendQuotaInGB', 'ProhibitSendReceiveQuotaInGB', 'RecoverableItemsQuotaInGB', 'RecoverableItemsWarningQuotaInGB', 'RulesQuotaInKB', 'MaxSendSizeInMB', 'MaxReceiveSizeInMB').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 10
                                Nullable  = $true
                            }
                        }))
            )
        }
        'ADUser'
        {
            @(
                $(@('mS-DS-ConsistencyGUID', 'msExchMailboxGUID', 'ObjectGUID').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))
                $(@('msExchMasterAccountSID', 'SID','DisplayName','Mail','DomainName','UserPrincipalName','Division','employeeType').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 256
                                Nullable  = $true
                            }
                        }))
                $(@('businesscategory','physicalDeliveryOfficeName').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 128
                                Nullable  = $true
                            }
                        }))
                $(@('City','Company','Country','Department', 'mailnickname','GivenName','Surname','SamAccountName').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 64
                                Nullable  = $true
                            }
                        }))
                @{
                    Name      = 'ProxyAddresses'
                    Type      = 'nvarchar'
                    MaxLength = 4000
                    Nullable  = $true
                }
                $(@('DistinguishedName','CanonicalName','Description','Manager').foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        }))
                $(@(1..15).foreach(
                        {
                            @{
                                Name      = 'ExtensionAttribute' + $_
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        }))
                $(@(16..45).foreach(
                        {
                            @{
                                Name      = 'msExchExtensionAttribute' + $_
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        }))
                $(@(1..5).foreach(
                        {
                            @{
                                Name      = 'msExchExtensionCustomAttribute' + $_
                                Type      = 'nvarchar'
                                MaxLength = 4000
                                Nullable  = $true
                            }
                        }))
                @{
                    Name     = 'initials'
                    Type     = 'nvarchar'
                    MaxLength = 6
                    Nullable = $true
                }
                @{
                    Name     = 'employeeID'
                    Type     = 'nvarchar'
                    MaxLength = 16
                    Nullable = $true
                }
                @{
                    Name     = 'employeeNumber'
                    Type     = 'nvarchar'
                    MaxLength = 512
                    Nullable = $true
                }
                @{
                    Name     = 'countryCode'
                    Type     = 'nchar'
                    MaxLength = 2
                    Nullable = $true
                }
                @{
                    Name     = 'Enabled'
                    Type     = 'bit'
                    Nullable = $true
                }
            )
        }
        'MailboxStats'
        {
            @(
                $(@('MailboxGuid'
                    #, 'OwnerADGuid'
                    #, 'ExternalDirectoryOrganizationID'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))

                $(@(
                        'TotalItemSizeInGB'
                        , 'TotalDeletedItemSizeInGB'
                        #, 'MessageTableTotalSizeInGB'
                        #, 'AttachmentTableTotalSizeInGB'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 10
                                Nullable  = $true
                            }
                        }))
                $(@(
                        'ItemCount'
                        , 'DeletedItemCount'
                        #, 'AssociatedItemCount'
                    ).foreach(
                        {
                            @{
                                Name     = $_
                                Type     = 'int'
                                Nullable = $true
                            }
                        }))
                $(@(
                        #'LastLoggoffTime'
                        #, 'LastLogonTime'
                    ).foreach(
                        {
                            @{
                                Name     = $_
                                Type     = 'DateTime'
                                Nullable = $true
                            }
                        }))
            )
        }
        'Permissions'
        {
            @(
                $(@(
                        'PermissionIdentity'
                        , 'ParentPermissionIdentity'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))
                $(@(
                        'SourceExchangeOrganization'
                        , 'TargetRecipientType'
                        , 'TargetRecipientTypeDetails'
                        , 'TargetAlias'
                        , 'TrusteeRecipientType'
                        , 'TrusteeRecipientTypeDetails'
                        , 'TrusteeAlias'
                        , 'TargetFolderType'
                        , 'PermissionType'
                        , 'AssignmentType'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 64
                                Nullable  = $true
                            }
                        }))
                $(@(
                        'TargetPrimarySMTPAddress'
                        , 'TrusteePrimarySMTPAddress'
                        , 'TrusteeIdentity'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 256
                                Nullable  = $true
                            }
                        }))
                $(@(
                        'TargetDistinguishedName'
                        , 'TrusteeDistinguishedName'
                        , 'TargetFolderPath'
                        , 'FolderAccessRights'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 1024
                                Nullable  = $true
                            }
                        }))
                $(@(
                        'TargetObjectGUID'
                        , 'TargetExchangeGUID'
                        , 'TrusteeGroupObjectGUID'
                        , 'TrusteeObjectGUID'
                        , 'TrusteeExchangeGUID'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nchar'
                                MaxLength = 36
                                Nullable  = $true
                            }
                        }))
                @{
                    Name     = 'IsAutoMapped'
                    Type     = 'nvarchar'
                    MaxLength = 5
                    Nullable = $true
                }
                @{
                    Name     = 'IsInherited'
                    Type     = 'nvarchar'
                    MaxLength = 5
                    Nullable = $true
                }
            )
        }
        'recipientMap'
        {
            @{
                Name      = 'TSourceOrganization'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            $(@('ExternalDirectoryObjectID', 'TExternalDirectoryObjectID').foreach(
                    {
                        @{
                            Name      = $_
                            Type      = 'nchar'
                            MaxLength = 36
                            Nullable  = $true
                        }
                    }))
            @{
                Name      = 'Alias'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name      = 'TAlias'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name      = 'PrimarySmtpAddress'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
            @{
                Name      = 'TPrimarySmtpAddress'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
            @{
                Name      = 'ExternalEmailAddress'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
            @{
                Name      = 'TExternalEmailAddress'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
            @{
                Name      = 'TCustomAttribute13'
                Type      = 'nvarchar'
                MaxLength = 1024
                Nullable  = $true
            }
            @{
                Name      = 'RecipientTypeDetails'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
            @{
                Name      = 'TRecipientTypeDetails'
                Type      = 'nvarchar'
                MaxLength = 256
                Nullable  = $true
            }
        }
        'configurationOrganization'
        {
            @{
                Name      = 'Name'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name      = 'MigrationRole'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name      = 'Credential'
                Type      = 'nvarchar'
                MaxLength = 1024
                Nullable  = $true
            }
            @{
                Name      = 'TenantDomain'
                Type      = 'nvarchar'
                MaxLength = 512
                Nullable  = $true
            }
            @{
                Name      = 'PrimaryDomain'
                Type      = 'nvarchar'
                MaxLength = 512
                Nullable  = $true
            }
            @{
                Name      = 'ConflictPrefix'
                Type      = 'nvarchar'
                MaxLength = 8
                Nullable  = $true
            }
            @{
                Name     = 'ConflictPriority'
                Type     = 'int'
                Nullable = $true
            }
        }
    }

    switch -wildcard ($TableType)
    {
        'q*'
        {
            @{
                Name      = 'Action'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name      = 'TargetOrganization'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
        }
        'action*'
        {
            @{
                Name      = 'Action'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
            @{
                Name     = 'WhenAction'
                Type     = 'DateTime'
                Nullable = $true
            }
            @{
                Name     = 'ActionResult'
                Type     = 'bit'
                Nullable = $true
            }
            @{
                Name      = 'ActionError'
                Type      = 'nvarchar'
                MaxLength = 1024
                Nullable  = $true
            }
            @{
                Name      = 'ActionNote'
                Type      = 'nvarchar'
                MaxLength = 1024
                Nullable  = $true
            }
            @{
                Name      = 'TargetOrganization'
                Type      = 'nvarchar'
                MaxLength = 64
                Nullable  = $true
            }
        }
    }

}