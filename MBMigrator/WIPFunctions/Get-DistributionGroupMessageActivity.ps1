Param(
    [datetime]$Start
    ,
    [parameter(Mandatory)]
    [ValidateScript( { Test-Path -type Container -Path $_ })]
    [string]$OutputFolderPath
)

$now = Get-Date
$Increment = 0

$GetParams = @{
    RecipientTypeDetails = 'MailUniversalDistributionGroup'
    ResultSize           = 'Unlimited'
    ErrorAction          = 'Stop'
}

$Identity = @(
    Get-EXORecipient @GetParams | Select-Object -ExpandProperty 'PrimarySMTPAddress'
)

while ($($now - $Start.AddDays($Increment)).Days -ge 0)
{
    if ($($now - $Start.AddDays($Increment)).Days -gt 0)
    {
        $yesterdayStart = $Start.AddDays($Increment)
        $TimeStamp = $yesterdayStart | Get-Date -Format yyyyMMdd
        $yesterdayEnd = $yesterdayStart.AddHours(24)

        Write-Information -InformationAction Continue -MessageData $TimeStamp
        $Results = @(
            Get-DistributionGroupMessageTrace -Identity $Identity -StartDate $yesterdayStart -EndDate $yesterdayEnd
        )

        $FileName = $TimeStamp + 'DGMessageTrace.csv'
        $ResultsFilePath = Join-Path -Path $OutputFolderPath -ChildPath $FileName

        $Results | Export-Csv -NoTypeInformation -Path $ResultsFilePath -Encoding UTF8
    }
    $Increment++
}