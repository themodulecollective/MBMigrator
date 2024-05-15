Function Export-MBMWaveMRSReport
{

    <#
.SYNOPSIS
    Exports an xml report for a move request's statistics, including the detailed report.
.DESCRIPTION
    Exports an xml report for a move request's statistics, including the detailed report.
.EXAMPLE
    Export-MBMWaveMRSReport -Wave 90.1 -OutputFolderPath e:\MBMigration\MRSReports\
    Exports an xml file containing move requests statistics report for each move request in Wave 90.1
#>
    [cmdletbinding()]
    param(
        #
        [string]$Wave
        ,
        #
        [parameter(Mandatory)]
        [validatescript({ Test-Path -Path $_ -PathType Container })]
        [string]$OutputFolderPath
        ,
        [switch]$CompressOutput
    )

    Get-MBMWaveMoveRequest -Wave $Wave -Global
    $MR = @(Get-WaveMoveRequestVariableValue -Wave $Wave)
    if ($CompressOutput)
    {
        $filesToCompress = [System.Collections.Generic.List[string]]::new()
    }

    $waveNameForFileName = $('Wave' + $Wave.Replace('.', '_'))

    $xProgressID = Initialize-xProgress -ArrayToProcess $MR -CalculatedProgressInterval 1Percent -Activity "Export MRS for $Wave"
    foreach ($r in $MR)
    {
        Write-xProgress -Identity $xProgressID
        $message = "Getting then Exporting MRS for $($r.Alias) $($r.exchangeguid.guid)"
        Write-Information -MessageData $message
        $s  = Get-MoveRequestStatistics -Identity $R.ExchangeGUID.guid -IncludeReport -DiagnosticInfo ShowTimeSlots
        $filename = $waveNameForFileName + '_' + $s.Alias + '_' + $s.ExchangeGUID.guid + '.xml'
        $filepath = Join-Path -Path $OutputFolderPath -ChildPath $filename
        $s | Export-Clixml -Path $filepath -Encoding UTF8
        if ($CompressOutput)
        {
            $filesToCompress.Add($filepath)
        }
    }
    Complete-xProgress -Identity $xProgressID

    if ($CompressOutput)
    {
        $archiveFilename = $waveNameForFileName + '.zip'
        $archiveFilepath = Join-Path -Path $OutputFolderPath -ChildPath $archiveFilename
        Compress-Archive -DestinationPath $archiveFilepath -Path $filesToCompress
        Remove-Item -Path $filesToCompress -Confirm:$false
    }
}
