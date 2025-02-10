. C:\Migration\Scripts\MBMConfiguration.ps1

Do {
$timespan = [timespan]::
Write-Verbose -Message "picking up next site and file to process" -Verbose
$FilesToProcess = @(Get-ChildItem C:\Migration\Data\CleanupBatches -File)
$sortedFiles = $FilesToProcess | Sort-Object -Property Length 
$myfile = $sortedFiles[0]

Write-Verbose -Message "Processing file $($myfile.fullname)" -Verbose
$movedFile = Move-Item $myfile -Destination C:\Migration\Data\CleanupBatches\Processing -PassThru
$siteItems = Import-Excel -Path $movedFile
Write-Verbose -Message "Procesing $($siteItems.count) file and folder items" -Verbose
$items = $siteitems.where({ $_.type -eq 'item' })
$Folders = $siteItems.where({ $_.type -eq 'folder' -and 'Migration Action' -eq 'Newly Created' })
$siteURL = $siteItems[0].site
Connect-PnPOnline -Url $siteURL -ClientId $MBMConfiguration.TargetTenantReportingAppID -Tenant $MBMConfiguration.TargetTenantDomain -Thumbprint $MBMConfiguration.CertificateThumbprint
Write-Log -Message "Connected to $siteURL" -Level INFO -Verbose
Write-Verbose -Message "Processing $($items.count) items" -Verbose
$items.foreach({
        $log = $_
        try {
            $message = "Removing File '$($log.relativeFilePath)'"
            Write-log -Message $message -Level INFO
            Remove-PnPFile -SiteRelativeUrl $log.relativeFilePath -Force -ErrorAction Stop
        }
        catch {
            Write-Log -Message "Failed: $message"
            Write-Log -Message $_.tostring()
        }          
    })

$folders = $folders | Sort-Object -Property 'Destination URL' -Descending

Write-Verbose -Message "Processing $($folders.count) folders" -Verbose
$folders.foreach({
        $log = $_
        $Folder = $log.{ Object Title }
        $relativeParent = if ($log.RelativeFilePath -eq '/Documents') { $log.RelativeFilePath } else { $log.relativeFilePath.substring(1, $log.relativefilepath.length - ($Folder.length + 2)) }
        try {
            $message = "Removing Folder '$Folder' from location '$relativeParent'"          
            Write-Log -Message $message -Level INFO
            Remove-PnPFolder -Name $Folder -Folder $relativeParent -Force -ErrorAction Stop                
        }
        catch {
            Write-Log -Message "Failed: $message"
            Write-Log -Message $_.tostring()
        }
    })

Disconnect-PnPOnline

Write-Verbose -Message "Completed Processing $($movedFile.fullname)" -Verbose
Move-Item $movedFile -Destination C:\Migration\Data\CleanupBatches\Completed
Write-Verbose -Message "Sleeping for 10 seconds" -Verbose
Start-Sleep -Seconds 10
}
Until (@(Get-ChildItem C:\Migration\Data\CleanupBatches -File) -eq 0)

