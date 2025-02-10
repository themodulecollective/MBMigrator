function Send-MBMWaveMessageViaGraph
{
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
        [Parameter(Mandatory)]
        [string[]]$To
        ,
        [Parameter()]
        [string]$From
        ,
        # Requires keys for HasPlaceholder(True/False), Placeholders(Key,Value), Subject, ContentType, Attachment(FilePath,DocuementType), FilePath
        [hashtable]$MessageDetails 
        ,
        [parameter(Mandatory)]
        [string]$Wave
    )

    $MessageContent = Get-Content -Path $MessageDetails.FilePath -Raw -ErrorAction Stop

    If ($MessageDetails.HasPlaceHolder)
    {
        $MessageDetails.Placeholders.Keys.ForEach({
                $key = $_
                switch ($key)
                {
                    { $_ -like '*Date*' }
                    {
                        $MessageContent = $MessageContent.Replace("{[$key]}", $($MessageDetails.Placeholders.$key | Get-Date -Format 'dddd, MMMM d'))
                    }
                    'Today'
                    {
                        $MessageContent = $MessageContent.Replace("{[Today]}", $(Get-Date -Format 'dddd, MMMM d'))
                    }
                    'MessageName'
                    {
                        $MessageContent = $MessageContent.Replace("{[MessageName]}", $MessageDetails.PlaceHolders.$key)
                    }
                    'Wave'
                    {
                        $MessageContent = $MessageContent.Replace("{[Wave]}", $Wave)
                    }
                    Default
                    {
                        $MessageContent = $MessageContent.Replace("{[$key]}", $($MessageDetails.Placeholders.$key))
                    }
                }
            })
    }

    $SendGraphMailParams = [ordered]@{
        From             = $From
        To               = $To
        BCC              = $MessageDetails.BCC
        Subject          = $MessageDetails.Subject
        MessageContent   = $MessageContent
        #MessageContentFromFile = $true
        MessageFormat    = 'HTML'
        DocumentType     = $MessageDetails.Attachment.DocumentType
        InlineAttachment = $true
        Importance       = $MessageDetails.Priority
        Attachments      = $Messagedetails.Attachment.FilePath
        ErrorAction      = 'Stop'
    }
    Send-GraphMail @SendGraphMailParams 
}



