Function New-MBMReverseMoveRequest
{
    <#
    .SYNOPSIS
        Creates new move requests for users moving back to source Exchange
    .DESCRIPTION
        Creates new move requests for users moving back to source Exchange
    .EXAMPLE
        New-MBMReverseMoveRequest -ExchangeCredential $cred -Identity $mailboxes -Endpoint mail.contoso.com -ReasonCode "Failed Trial Wave" -TargetDeliveryDomain contoso.com -RemoteTargetDatabase "DB01"
        For each mailbox in $mailboxes, a new move request will be created
    #>

    [cmdletbinding()]
    param(
        #Exchange On Premises Credential
        [parameter(Mandatory)]
        [pscredential]$ExchangeCredential
        ,
        #Identities of the mailboxes to be migrated back to on premises exchange
        [parameter(Mandatory)]
        [string[]]$Identity
        ,
        #Migration Endpoint or FQDN on premises
        [parameter(Mandatory)]
        [string]$Endpoint
        ,
        # a very brief explanation for the move back.  "Reason:" will be prepended
        [parameter(Mandatory)]
        [string]$ReasonCode
        ,
        #An on premises email address domain that the recipient has
        [parameter(Mandatory)]
        $TargetDeliveryDomain
        ,
        #Required when moving only the primary mailbox back to exchange on premises.  Points to the tenant *.mail.onmicrosoft.com domain
        [parameter()]
        $ArchiveDomain
        ,
        #On Premises Mailbox Database target for the migration.  Quotas must allow for the mailbox size.
        [parameter(Mandatory)]
        $RemoteTargetDatabase
        ,
        # use to include the archive mailbox in the migration back to on premises
        [switch]$IncludeArchive
        ,
        # use to auto complete the move request without suspending.  this function suspends the move request by default
        [switch]$NoSuspend
    )
    $Counter = -1
    $NewMoveRequestParams = @{
        BadItemLimit               = 99
        LargeItemLimit             = 99
        TargetDeliveryDomain       = $TargetDeliveryDomain
        RemoteTargetDatabase       = $RemoteTargetDatabase
        AcceptLargeDataLoss        = $true
        SuspendWhenReadyToComplete = $true
        Outbound                   = $true
        WarningAction              = 'SilentlyContinue'
        PrimaryOnly                = $true
    }
    if (-not [string]::IsNullOrEmpty($ArchiveDomain))
    {
        $NewMoveRequestParams.PrimaryOnly = $true
        $NewMoveRequestParams.ArchiveDomain = $ArchiveDomain
    }
    switch ($true)
    {
        { $true -eq $NoSuspend }
        { $NewMoveRequestParams.SuspendWhenReadyToComplete = $false }
        { $true -eq $IncludeArchive }
        {
            $NewMoveRequestParams.PrimaryOnly = $false
        }
    }
    $Identity.ForEach( {
            $Counter++
            $RemoteHostName = $Endpoint
            #$RemoteHostName = $EndPoint.$($_.ExchangeOrg)[$($Counter % $EndPoint.Count)]
            $MemberParams = @{
                RemoteHostName   = $RemoteHostName
                Identity         = $_
                BatchName        = 'Reverse:' + $ReasonCode
                #RemoteCredential = $ExchangeCredential.$($_.ExchangeOrg)
                RemoteCredential = $ExchangeCredential
            }
            Write-Information -MessageData $('New-MoveRequest ' + $($MemberParams.GetEnumerator().foreach( { '-' + $_.Name + ':' + $_.Value }) -join ' '))
            New-MoveRequest @NewMoveRequestParams @MemberParams
        })

}
