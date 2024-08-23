#
# Module manifest for module 'MBMigrator'
#
# Generated by: Mike Campbell
#
# Generated on: 12/21/2019
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = '.\MBMigrator.psm1'

    # Version number of this module.
    ModuleVersion        = '0.0.0.40'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID                 = '6a94d4dd-934a-408a-ad6e-c489cd4456bf'

    # Author of this module
    Author               = 'Mike Campbell'

    # Company or vendor of this module
    CompanyName          = 'themodulecollective'

    # Copyright statement for this module
    Copyright            = '2024'

    # Description of the functionality provided by this module
    Description          = 'a PowerShell Module for managing Mailbox Migrations to Exchange Online using Move Requests'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules      = @(
        #@{ModuleName = 'PSFramework'; ModuleVersion = '1.1.59' }
        #@{ModuleName = 'dbatools'; ModuleVersion = '1.1.127'}
        #@{ModuleName = 'ExchangeOnlineManagement'; ModuleVersion = '2.0.5'}
        #@{ModuleName = 'xProgress'; ModuleVersion = '0.0.2'}
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the callers environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'Complete-MBMWave'
        'Convert-CSExportXMLToCSV'
        'Export-ADUser'
        'Export-ADComputer'
        'Export-ADGroup'
        'Export-EntraIDLicensing'
        'Export-EntraIDUserLicensing'
        'Export-EntraIDUserDrive'
        'Export-PNPUserDriveDetail'
        'Export-EntraIDUser'
        'Export-EntraIDGroup'
        'Export-IntuneDevice'
        'Export-ExchangeConfiguration'
        'Export-ExchangeOnlineProtection'
        'Export-ExchangeRecipient'
        'Export-ExchangeOPDLOwnership'
        'Export-ComplianceRetentionPolicy'
        'Export-ExchangeRetentionPolicy'
        'Export-MoveRequest'
        'Export-UnifiedGroupDrive'
        'Export-UnifiedGroupMember'
        'Export-UnifiedGroupOwner'
        'Export-MBMReport'
        'Get-DistributionGroupMessageTrace'
        'Get-MBMMigrationList'
        'Get-SecurityPrincipalCloudStatus'
        #'Get-SortableSizeValue'
        'Get-WaveDataGlobalVariable'
        'Get-MBMWaveMember'
        'Get-MBMWaveMissingMoveRequest'
        #'Get-WaveMemberVariableValue'
        'Get-MBMWaveWrongMoveRequest'
        'Get-MBMWaveNonMemberMoveRequest'
        'Get-MBMWaveMoveRequest'
        'Get-MBMWaveMoveRequestStatistics'
        #'Get-WaveMoveRequestVariableValue'
        #'Get-WaveMoveRequestStatisticsVariableValue'
        'Get-MBMWaveUnassignedMoveRequest'
        'Get-MBMWaveRequestReport'
        'Get-MBMWaveRequestStatisticsReport'
        'Invoke-MBMWavePostMigrationProcess'
        #'New-SplitArrayRange'
        #'New-Timer'
        #'Group-Join'
        'New-MBMWaveMoveRequest'
        #'Remove-WaveDataGlobalVariable'
        #'Send-OutlookMail'
        'Send-MBMWaveMessage'
        'Send-MBMWaveMoveRequestCompletedMessage'
        'Set-MBMMigratedCASMailbox'
        'Set-MBMMigratedMailboxDefaultPFM'
        'Set-MBMMigratedMailboxForwarding'
        'Set-MBMMigratedMailboxQuota'
        'Set-MBMMigratedMailboxRetentionPolicy'
        'Set-MBMMigratedMailboxSendReceive'
        'Switch-MBMWaveMoveRequestEndpoint'
        'Sync-MBMWaveMoveRequest'
        'Update-MBMRecipientData'
        'Update-MBMPermissionData'
        'Update-MBMFromExcelFile'
        'Get-MBMConfiguration'
        'Get-MBMColumnMap'
        'Set-MBMConfiguration'
        'Update-MBMDatabaseSchema'
        'Update-MBMWavePlanning'
        'Update-MBMDelegateAnalysis'
        'New-MBMReverseMoveRequest'
        'Export-MBMWaveMRSReport'
        'Update-MBMActiveDirectoryData'
        #'Start-ExchangeThreadJob'
    )
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    #CmdletsToExport   = '*'

    # Variables to export from this module
    #VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    #AliasesToExport   = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @('PSModule', 'Exchange', 'Mailbox', 'Migration')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/themodulecollective/MBMigrator/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/themodulecollective/MBMigrator'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

    # DefaultCommandPrefix = ''

    # DefaultCommandPrefix}=}''

}
