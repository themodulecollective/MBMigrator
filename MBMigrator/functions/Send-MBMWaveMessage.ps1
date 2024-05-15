function Send-MBMWaveMessage {
    <#
    .SYNOPSIS
        Send standardized coms built into this module to wave members
    .DESCRIPTION
        Send standardized coms built into this module to wave members to keep them informed as the wave progresses from T-10.
    .EXAMPLE
        Send-MBMWaveMessage -Wave "1.1" -MessageName T-10 -MessageRepository "C:\Users\Username\Repo" -WavePlanningFilePath "C:\Users\Username\Documents\WavePlanning.xlsx"
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        [string]$Wave
        ,
        #
        [parameter(Mandatory)]
        [ValidateSet('T-10', 'T-5', 'T-3', 'T-R', 'T-1', 'T-P', 'T-C', 'T-S', 'T-1S')]
        [string]$MessageName
        ,
        #
        [parameter(Mandatory)]
        [validateScript( { Test-Path -Path $_ -PathType Container })]
        [string]$MessageRepository
        ,
        #
        [parameter(Mandatory)]
        [validateScript( { Test-Path -Path $_ -PathType Leaf })]
        [string]$WavePlanningFilePath
        ,
        #
        [switch]$SendAdditionalBCC
        ,
        #
        [switch]$Test
        ,
        #
        [psobject[]]$SpecifiedRecipients
        ,
        #
        [psobject[]]$TestRecipients #object must have primarysmtpaddress attribute
    )

    $WaveMembers = Get-WaveMemberVariableValue -Wave $Wave

    Switch ($MessageName) {
        'T-1S' {
            $WaveMembers = $WaveMembers.where( { $_.RecipientTypeDetails -notin @('UserMailbox', 'LinkedMailbox') })
        }
        'T-C' {
            $WaveMembers = $SpecifiedRecipients
        }
        'T-S' {
            $WaveMembers = $WaveMembers.where( { $_.RecipientTypeDetails -in @('UserMailbox', 'LinkedMailbox', 'RemoteUserMailbox') })
        }
        'T-R' {
            $WaveMembers = $SpecifiedRecipients
        }
        'T-P' {
            $WaveMembers = $SpecifiedRecipients
        }
        Default {
            $WaveMembers = $WaveMembers.where( { $_.RecipientTypeDetails -in @('UserMailbox', 'LinkedMailbox') })
        }
    }

    if ($Specified.Count -ge 1) {
        $WaveMembers = $Specified
    }

    $AllTargetDates = Import-Excel -Path $WavePlanningFilePath -WorksheetName 'TargetDates' -ErrorAction Stop
    $WaveTargetDates = $AllTargetDates.where( { $_.Wave -eq $Wave })
    if ($null -eq $WaveTargetDates) { throw("Target Dates for $Wave NOT found in TargetDates Worksheet in the Wave Planning file.") }

    $AllMessageDetails = Import-Excel -Path $WavePlanningFilePath -WorksheetName 'Messages' -ErrorAction Stop
    $MessageDetails = $AllMessageDetails.where( { $_.Name -eq $MessageName })
    if ($null -eq $MessageDetails) { throw("Message Details for $MessageName NOT found in Messages Worksheet in the Wave Planning file.") }

    $MessageFileName = $MessageDetails.BodyContentFilePath
    $MessageFilePath = Join-Path -Path $MessageRepository -ChildPath $MessageFileName
    $MessageContent = Get-Content -Path $MessageFilePath -Raw -ErrorAction Stop
    If (-not [string]::IsNullOrWhiteSpace($MessageDetails.BodyContainsPlaceHolders)) {
        $Placeholders = @($MessageDetails.BodyContainsPlaceHolders.split('|'))
        $Placeholders.ForEach( {
                $MessageContent = $MessageContent.Replace("{[$_]}", $($WaveTargetDates.$_ | Get-Date -Format 'dddd, MMMM d'))
            })
    }
    $MessageContent = $MessageContent.Replace("{[MessageName]}", $MessageName)
    $MessageContent = $MessageContent.Replace("{[Wave]}", $Wave)

    switch ($Test) {
        $true {
            $Recipients = @(
            )
            Write-Information -MessageData "Sending Test Message to Recipients $($Recipients.primarysmtpaddress -join ';'). Actual message would be sent to the following addresses: $($WaveMembers.PrimarySMTPAddress -join ';')"
        }
        $false {
            $Recipients = $WaveMembers
        }

    }

    $Ranges = @(New-SplitArrayRange -inputArray $Recipients -size 250)

    $SendOutlookMailParams = @{
        Subject    = $MessageDetails.Subject
        Body       = $MessageContent
        BodyAsHtml = $true
        Attachment = $MessageDetails.Attachments.split('|').foreach( { Join-Path -Path $MessageRepository -ChildPath $_ })
        To         = $MessageDetails.To
        SendAS     = $MessageDetails.From
        Priority   = $MessageDetails.Priority
    }

    $Ranges.foreach( {
            $SendOutlookMailParams.BCC = @($Recipients[$($_.Start)..$($_.End)].PrimarySMTPAddress)
            if ($SendAdditionalBCC)
            { $SendOutlookMailParams.BCC += $MessageDetails.BCC.split('|') }
            Send-OutlookMail @SendOutlookMailParams
        })
}