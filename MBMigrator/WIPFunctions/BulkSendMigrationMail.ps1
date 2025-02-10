
$SendMWMVG = @{
    To             = $null
    From           = 'sender'
    Wave           = '15.1'
    MessageDetails = @{
        BCC            = 'bccrecipients'
        HasPlaceHolder = $true
        Subject        = 'Microsoft Account Migration Update - Shared Mailbox Setup Confirmation'
        PlaceHolders   = @{
            SourceMail  = $null
            TargetMail  = $null
            Today       = $true
            MessageName = 'SharedMailbox-MigrationCompleteNotification'
            Wave        = $true
        }
        Priority       = 'High'
        MessageFormat  = 'HTML'
        FilePath       = 'C:\Migration\Messages\EXO-Shared-Message.html'
        Attachment     = @{
            FilePath     = 'C:\Migration\Messages\logo.jpg'
            DocumentType = 'image/jpeg'
        }
    }
}

$wave[6..999].foreach({
        $e = $_
        $SendMWMVG.To = @($e.TargetMail, $e.SourceMail)
        $SendMWMVG.MessageDetails.PlaceHolders.SourceMail = $e.SourceMail
        $SendMWMVG.MessageDetails.PlaceHolders.TargetMail = $e.TargetMail
        Write-Log -level INFO -Message "Running: Send Migration Notification to $($e.SourceMail) -> $($e.TargetMail)"
        try
        {
            Send-MBMWaveMessageViaGraph @SendMWMVG -ErrorAction Stop
            Write-Log -level INFO -Message "Completed: Send Migration Notification to $($e.SourceMail) -> $($e.TargetMail)"
        }
        catch
        {
            Write-Log -Level WARNING -Message "Failed: Send Migration Notification to $($e.SourceMail) -> $($e.TargetMail)"
            Write-Log -Level WARNING -Message $_.tostring()
        }
        Start-Sleep -Seconds 1
    })