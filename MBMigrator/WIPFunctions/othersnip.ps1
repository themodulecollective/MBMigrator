#Size From Move Request
$mrs.foreach( {
        [pscustomobject]@{
            DisplayName     = $_.DisplayName
            MBPerHour       = [int]$(
                $_.bytesTransferred.tostring().split(@('(', ')', ' '))[3].replace(',', '') / $_.TotalInProgressDuration.TotalHours / 1MB
            )
            TotalMBSizeInGB = [int]$(
                $_.TotalMailboxSize.tostring().split(@('(', ')', ' '))[3].replace(',', '') / 1GB
            )
            ExchangeGUID    = $_.ExchangeGUID.guid
        }
    })