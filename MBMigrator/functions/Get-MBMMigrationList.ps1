Function Get-MBMMigrationList {
    <#
.SYNOPSIS
    Gets the Mailbox Migration List
.DESCRIPTION
    Gets the Mailbox Migration List from a specified Excel spreadsheet or by querying the database
.EXAMPLE
    Get-MBMMigrationList
    Gets the current Mailbox Migration List from the SQL database and prints it to the terminal
#>

    [cmdletbinding(DefaultParameterSetName = 'SQL')]
    param
    (
        #
        [parameter()]
        [switch]$Global
        ,
        #
        [parameter(Mandatory, ParameterSetName = 'ExcelFile')]
        [ValidateScript( { Test-Path -Path $_ -PathType Leaf -Filter *.xlsx })]
        [string]$FilePath
        ,
        [parameter(Mandatory, ParameterSetName = 'SPO')]
        [switch]$SPOList
    )

    $GetDataParams = @{}
    if ($Global) { $GetDataParams.OutVariable = 'Global:MailboxMigrationList' }
    $CurrentList = @(
        switch ($PSCmdlet.ParameterSetName) {
            'SQL' {
                $configuration = Get-MBMConfiguration
                $dbiParams = @{
                    SQLInstance = $configuration.SQLInstance
                    Database    = $configuration.Database
                }
                $iQParams = @{
                    Query = 'select * from dbo.staticMigrationList'
                    AS    = 'PSObject'
                }
                Invoke-DbaQuery @dbiParams @iQParams @GetDataParams
            }
            'ExcelFile' {
                Import-Excel -Path $FilePath @GetDataParams
            }
            'SPO'
            {

            }
        }
    )
    if (-not $Global) {
        $CurrentList
    }


}
