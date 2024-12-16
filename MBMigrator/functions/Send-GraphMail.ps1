function Send-GraphMail
{
<#
.SYNOPSIS
   Send email using microsoft Graph User SendMail endpoint
.DESCRIPTION
  Send email using microsoft Graph User SendMail endpoint
.NOTES
  derived from https://www.powershellcenter.com/2022/09/07/powershell-script-to-simplify-send-mgusermail/
.PARAMETER
    Send-GraphMail Support the following parameters
    [Array] To: The recipients address, it can be an array for multiple account, just make sure to include the array type @("User1@domain.com","User2@Domain.com")
    [Array] Bcc: Similar to To, but this is the BCC and also support array of recipients
    [Array] CC: Similar to To and Bcc, also support array of recipients.
    [String] Subject: The Message Subject
    [String] MessageFormat: it can be HTML or Text
    [String] Body: The Message Body you want to send.
    [Switch] BodyFromFile: This is a Switch parameter. Using it mean that the body is stored in a file in your harddrive. When using the BodyFromFile, the Body parameter should be the full path of the file.
    [Switch] DeliveryReport: Set to receive a delivery report email or not
    [Switch] ReadReport: set to receive a read report or not.
    [Switch] Flag: enable the follow-up flag for the message
    [ValicationSet] Importance: Set the message priority, it can be one of the following, Low or High
    [String] Attachments: The Attachment file path. For now it only support 1 attachment, if you want more, let me know
    [String] DocumentType: The attachment MIME type, for example for text file, the DocumentType is text/plain
    [Switch] ReturnJSON: This wont send the email, but instead it return the JSON file fully structured and ready so you can invoke it with any other tool.
    [HashTable] MultiAttachment: Use this parameter to send more than one attachment, this parameter is a Hashtable as the following @{"Attachment Path No.1"="DocumentType";"Attachment Path No.2"="DocumentType"}. You cannot use the MultiAttachment with Attachments parameter
    [Switch] GraphDebug: Return the debug log for the process
    ##############
    NOT included, Beta endpoins are not included, such as Mentions.

.EXAMPLE
Send Graph email message to multiple users with attachments and multiple To, CC and single Bcc
Send-GraphMail -To @('user1@domain.com','user2@domain.com') -CC @('cc@domain.com','cc1@domain.com) -Bcc "bcc@domain.com" -Subject "Test Message" -MessageFormat HTML -Body 'This is the Message Body' -DeliveryReport -ReadReport -Flag -Importance High -Attachments C:\MyFile.txt -DocumentType 'text/plain'

Send Graph email, load the Body from a file stored locally, make sure to use the BodyFromFile switch
send-GraphMail -To 'user1@domain.com' -Subject "Test Message" -MessageFormat HTML -Body C:\11111.csv -BodyFromFile -DeliveryReport -ReadReport -Flag -Importance High -Attachments 'C:\MyFile.txt' -DocumentType 'text/plain'

Return and get how the JSON is structured without sending the Email, this is done by using the -ReturnJSON Parameter
$JSONFile=Send-GraphMail -To 'user1@domain.com' -Subject "Test Message" -MessageFormat HTML -Body "Hi This is New Message" -Flag -ReturnJSON

Send Graph email including multiple attachment.
Send-GraphMail -To "ToUser@powershellcenter.com" -CC "farisnt@gmail.com" -Bcc "CCUser@powershellcenter.com" -Subject "Test V1" -MessageFormat HTML -Body "Test" -MultiAttachment @{"C:\11111.csv"="text/plain";"C:\222222.csv"="text/plain"}

#> 

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$To
        ,
        [Parameter()]
        [string[]]$From
        ,
        [Parameter()]
        [string[]]$CC
        ,
        [Parameter()]
        [string[]]$Bcc
        ,
        [Parameter()]
        [string]$Subject
        ,
        [Parameter()]
        [ValidateSet('HTML', 'Text')]
        [string]$MessageFormat
        ,
        [Parameter(ParameterSetName = 'Body')]
        [parameter(ParameterSetName = 'Attach')]
        [parameter(ParameterSetName = 'Attachmore')]
        [string]$MessageContent
        ,
        [Parameter(Mandatory = $false, ParameterSetName = 'Body')]
        [parameter(ParameterSetName = 'Attach')]
        [parameter(ParameterSetName = 'Attachmore')]
        [Switch]$MessageContentFromFile
        ,
        [Parameter(Mandatory = $false)][switch]$DeliveryReport
        ,
        [Parameter(Mandatory = $false)][switch]$ReadReport
        ,
        [Parameter(Mandatory = $false)][switch]$Flag
        ,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Low', 'High')] $Importance
        ,
        [Parameter(Mandatory = $false, ParameterSetName = 'Attach')]$Attachments
        ,
        [Parameter(Mandatory = $True, ParameterSetName = 'Attach')]$DocumentType
        ,
        [Parameter(Mandatory = $false)][switch]$ReturnJSON
        ,
        [Parameter(Mandatory = $false)][switch]$GraphDebug
        ,
        [Parameter(Mandatory = $True, ParameterSetName = 'Attachmore')][Hashtable]$MultiAttachment
        ,
        [switch]$InlineAttachment
    )

    $Body = [ordered]@{} 
    $Body.Message = @{}

    ## Body Subject Parameter
    switch ($PSBoundParameters.ContainsKey('Subject'))
    {
        $true { $Body.Message.Add('Subject', $Subject) }
        $false {}
    }
    ## DeliveryReport
    switch ($PSBoundParameters.ContainsKey('DeliveryReport'))
    {
        $true { $Body.Message.Add('isDeliveryReceiptRequested', "True") }
        $false {}
    }

    ## Flag
    switch ($PSBoundParameters.ContainsKey('Flag'))
    {
        $true { $Body.Message.Add('flag', @{flagStatus = "flagged" }) }
        $false {}
    }


    ## Read Report
    switch ($PSBoundParameters.ContainsKey('ReadReport'))
    {
        $true { $Body.Message.Add('isReadReceiptRequested', "True") }
        $false {}
    }
    ## $Importance
    switch ($PSBoundParameters.ContainsKey('Importance'))
    {
        $true { $Body.Message.Add('Importance', $Importance) }
        $false {}
    }

    ## Body Parameter
    switch ($PSBoundParameters.ContainsKey('MessageContent'))
    {
        $true
        { 
            $Body.Message.Add('Body', @{})
            $Body.Message.Body.Add('ContentType', $PSBoundParameters['MessageFormat'])
            if ($PSBoundParameters.ContainsKey('MessageContentFromFile'))
            {
                try
                {
                    $MessageBody = Get-Content -Path ($PSBoundParameters['MessageContent']) -Raw -ErrorAction stop
                    $Body.Message.Body.Add('Content', $MessageBody)
                }
                catch
                {
                    write-host "Cannot Attach Body, The error is " -ForegroundColor Yellow
                    Throw $_.Exception
                }
            }
            Else
            {
                $Body.Message.Body.Add('Content', $PSBoundParameters['MessageContent'])
            }
        }
        $false {}
    }

    ## Attachment Parameter
    switch ($PSBoundParameters.ContainsKey('Attachments'))
    {
        $true
        {
            Write-Verbose -Message "processing Attachments"
            $AttachmentTables = @(
                Foreach ($Singleattach In $Attachments)
                { 
                    Write-Verbose "processing $Singleattach"
                    $AttachDetails = @{}
                    $AttachDetails.Add("@odata.type", "#microsoft.graph.fileAttachment")
                    $AttachDetails.Add('Name', $(split-path -Path $Singleattach -Leaf))
                    $AttachDetails.Add('ContentType', $DocumentType)
                    $AttachDetails.Add('ContentBytes', [Convert]::ToBase64String([IO.File]::ReadAllBytes($Singleattach)))
                    
                    if ($PSBoundParameters.InlineAttachment)
                    { 
                        $AttachDetails.Add('ContentId', $AttachDetails.Name)
                        $AttachDetails.Add('IsInline', $true)
                    }
                    $AttachDetails
                }
            )
            Write-Verbose -Message $($AttachmentTables | convertto-json)
            $Body.Message.Add('Attachments', $AttachmentTables)
        
        }
        $false {}
    }

    ## MultiAttachment
    switch ($PSBoundParameters.ContainsKey('MultiAttachment'))
    {
        $true
        {
            $Body.Message.Add('Attachments', @()) 
            Foreach ($SingleattachinMulti In $MultiAttachment.GetEnumerator())
            { 
                $AttachmultiDetails = @{}
                $AttachmultiDetails.Add("@odata.type", "#microsoft.graph.fileAttachment")
                $AttachmultiDetails.Add('Name', $SingleattachinMulti.Name)
                $AttachmultiDetails.Add('ContentType', $SingleattachinMulti.Key)
                $AttachmultiDetails.Add('ContentBytes', [Convert]::ToBase64String([IO.File]::ReadAllBytes($SingleattachinMulti.Name)))
                $Body.message.Attachments += $AttachmultiDetails
            }

        }
        $false {}
    }

    ## No Recp is selected, the fail
    if ((!($PSBoundParameters.ContainsKey('To'))) -and (!($PSBoundParameters.ContainsKey('Bcc'))) -and (!($PSBoundParameters.ContainsKey('Bcc'))) )
    {
        Throw "You need to use one Address parameter To or CC or BCC"
    }
    ## To Parameter
    switch ($PSBoundParameters.ContainsKey('To'))
    {
        $true
        {
            $Body.Message.Add('ToRecipients', @()) 
            Foreach ($SingleToAddress In $To)
            {
                $Body.message.ToRecipients += @{EmailAddress = @{Address = $SingleToAddress } }
            }

        }
        $false {}
    }

    ## CC Parameter
    switch ($PSBoundParameters.ContainsKey('cc'))
    {
        $true
        {
            $Body.Message.Add('CcRecipients', @()) 
            Foreach ($SingleCCAddress In $cc)
            {
                $Body.message.CcRecipients += @{EmailAddress = @{Address = $SingleCCAddress } }
            }
        }
        $false {}
    }

    ## Bcc Parameter
    switch ($PSBoundParameters.ContainsKey('Bcc'))
    {
        $true
        {
            $Body.Message.Add('BccRecipients', @()) 
            Foreach ($SingleBCCAddress In $Bcc)
            {
                $Body.message.BccRecipients += @{EmailAddress = @{Address = $SingleBCCAddress } }
            }
        }
        $false {}
    }

    switch ($PSBoundParameters.ContainsKey('ReturnStructure'))
    {
        $true { return  $Body }
    }

    switch ($PSBoundParameters.ContainsKey('ReturnJSON'))
    {
        $true { return  ($Body | ConvertTo-Json -Depth 100) }
    }



    $InvGraphReqParams = @{
        Body   = $Body
        Method = 'POST'
    }

    switch ($PSBoundParameters.ContainsKey('GraphDebug'))
    {
        $true
        {
            $InvGraphReqParams.Debug = $true
        }
    }
    switch ([string]::IsNullOrWhiteSpace($From))
    {
        $true #send from logged in user
        {
            $InvGraphReqParams.URI = 'https://graph.microsoft.com/v1.0/me/sendMail'
        }
        $false #sendAs specified From user
        {
            $InvGraphReqParams.URI = "https://graph.microsoft.com/v1.0/users/$from/sendMail"
        }
    }

    
    Invoke-GraphRequest @InvGraphReqParams

}