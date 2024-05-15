function Export-MoveRequest
{
    <#
    .SYNOPSIS
        Exports Move Requests from Exchange
    .DESCRIPTION
        Export Move Requests from Exchange to Excel Files for the specified RemoteHostName.
    .EXAMPLE
        Export-MoveRequest -OutpuFolderPath "C:\Users\UserName\Documents" -RemoteHostName $RemoteHostName
        Exports all move reuqests to the specified file location in an xlsx file
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [ValidateScript( { Test-Path -type Container -Path $_ })]
        [string]$OutputFolderPath
        ,
        #
        [parameter(Mandatory)]
        [string]$RemoteHostName
    )


    #Write-Verbose -Verbose -Message 'Export-MoveRequest'

    $ErrorActionPreference = 'Continue'

    #For commands that support Recipient Filtering
    $GetRParams = @{
        ResultSize    = 'Unlimited'
        WarningAction = 'SilentlyContinue'
        RemoteHostName = $RemoteHostName
    }

    $ExchangeOrgConfig = [PSCustomObject]@{
        OrganizationConfig = Get-OrganizationConfig
    }

    $MoveRequests = Get-MoveRequest @GetRParams |
        Select-Object -ExcludeProperty User,UserGuid,ExchangeGUID,Identity -property *,@{n='User';e={$_.User.tostring()}},@{n='UserGuid';e={$_.UserGuid.tostring()}},@{n='ExchangeGUID';e={$_.ExchangeGUID.tostring()}},@{n='Identity';e={$_.Identity.tostring()}}

    $DateString = Get-Date -Format yyyyMMddHHmmss

    $OutputFileName = $($ExchangeOrgConfig.OrganizationConfig.guid.guid.split('-')[0]) + $RemoteHostName + 'MoveRequestsAsOf' + $DateString
    $OutputFilePath = Join-Path $OutputFolderPath $($OutputFileName + '.xlsx')

    $MoveRequests | Export-Excel -Path $OutputFilePath

}