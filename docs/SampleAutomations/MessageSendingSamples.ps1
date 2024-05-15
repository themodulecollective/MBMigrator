

# T-5 Test
$SWMM = @{
    Wave                 = '10.2'
    MessageName          = 'T-5'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    SendAdditionalBCC    = $true
    #Test                 = $true
    #InformationAction    = 'Continue'
}
Send-MBMWaveMessage @SWMM

# T-5 Test
$SWMM = @{
    Wave                 = '7.1'
    MessageName          = 'T-10'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WaveMembers          = $Wave7_1.where( { $_.RecipientTypeDetails -in @('UserMailbox', 'LinkedMailbox') })
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    #SendAdditionalBCC    = $true
    Test                 = $true
}
Send-MBMWaveMessage @SWMM

#send an actual migration mail message


#in progress

$SWMM = @{
    Wave                 = '9.1'
    MessageName          = 'T-P'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    SpecifiedRecipients  = $Specified
    #SendAdditionalBCC    = $true
    Test                 = $true
    InformationAction    = 'Continue'
}
Send-MBMWaveMessage @SWMM


#shared mailbox
$SWMM = @{
    Wave                 = '5.2'
    MessageName          = 'T-1S'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WaveMembers          = $Wave5_2.where( { $_.RecipientTypeDetails -notin @('UserMailbox', 'LinkedMailbox') })
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    #SendAdditionalBCC    = $true
    Test                 = $true
}
Send-MBMWaveMessage @SWMM

#Survey
$SWMM = @{
    Wave                 = '5.1'
    MessageName          = 'T-S'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WaveMembers          = $Wave5_1.where( { $_.RecipientTypeDetails -in @('UserMailbox', 'LinkedMailbox', 'RemoteUserMailbox') })#( { $_.RecipientTypeDetails -eq 'RemoteUserMailbox' })
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    #SendAdditionalBCC    = $true
    Test                 = $true
}
Send-MBMWaveMessage @SWMM

$SWMM = @{
    Wave                 = '10.1'
    MessageName          = 'T-R'
    MessageRepository    = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\Messages\'
    WavePlanningFilePath = 'C:\Users\MikeCampbell\GitRepos\MigrationTracking\WavePlanning.xlsx'
    #SendAdditionalBCC    = $true
    Test                 = $true
    InformationAction    = 'Continue'
}
Send-MBMWaveMessage @SWMM