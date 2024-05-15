Function New-MigrationDistributionGroup {
    <#
    .SYNOPSIS
        Creates a distribution group from excel spreadsheet, verifies members are recipients, and reports any missing members
    .DESCRIPTION
        Creates a distribution group from excel spreadsheet, verifies members are recipients, and reports any missing members.
    .EXAMPLE
        New-MigrationDistributionGroup -InputExcelFile "C:\Users\UserName\Documents\excelFile.xls" -WorksheetName "Sheet 1" -ManagedBy migration@contoso.com -OutputFolder "C:\Users\UserName\Documents\" -EmailDomain "contoso.onmicrosoft.com"
        Creates a distribution group managed by migration@contoso.com from excelFile.xls members list on sheet 1 and outputs a report to C:\Users\UserName\Documents\
    #>
    
    #requires
    param(
        #[string[]]$RawMembers
        #
        [string]$InputExcelFile
        ,
        #
        [string]$WorksheetName
        ,
        #
        [string]$ManagedBy #email address or other valid identifier of owner
        ,
        #
        [string]$OutputFolder
        ,
        #
        [string]$EmailDomain #like something.onmicrosoft.com
    )

    $RawMembers = Import-Excel -Path $InputExcelFile -WorksheetName $WorksheetName -ErrorAction Stop | Select-Object -ExpandProperty Emails -ErrorAction Stop

    if ($RawMembers.count -eq 0 -or [string]::IsNullOrWhiteSpace($RawMembers[0]))
    { throw ("No Members found in file $inputExcelFile on sheet $WorksheetName") }

    $missing = [System.Collections.Generic.List[string]]::new()
    $found = [System.Collections.Generic.List[string]]::new()

    $found = @(
        $RawMembers.foreach( {
                $raw = $_
                try {
                    Get-Recipient -Identity $raw -errorAction Stop | Select-Object -ExpandProperty PrimarySMTPAddress
                }
                catch {
                    $missing.add($raw)
                }
            })
    )

    $found = @($found | Select-Object -Unique)

    $Name = $([guid]::NewGuid()).guid

    $DisplayName = "$name $WorksheetName"

    $newDGParams = @{
        Name                               = $Name
        DisplayName                        = $DisplayName
        RequireSenderAuthenticationEnabled = $false
        ManagedBy                          = $ManagedBy
        Members                            = $found
        PrimarySMTPAddress                 = $Name + '@' + $EmailDomain
    }

    $group = New-DistributionGroup @newDGParams
    #Start-Sleep -Seconds 2
    #Set-DistributionGroup -identity $newDGParams.PrimarySMTPAddress -HiddenFromAddressListsEnabled $true

    $Report = [PSCustomObject]@{
        Group                   = $group
        RawMembers              = $RawMembers
        MissingMembers          = $missing
        ValidatedDedupedMembers = $found
    }

    $outputFileName = Join-Path -Path $OutputFolder -ChildPath "$DisplayName.xlsx"

    $ExportExcelParams = @{
        FreezeTopRow = $true
        TableStyle   = 'Medium1'
        AutoSize     = $true
        Path         = $outputFileName
    }

    $Report.Group | Select-Object -Property Name, DisplayName, PrimarySMTPAddress | Export-Excel -WorksheetName 'GroupDetails' @ExportExcelParams
    $Report.RawMembers | Export-Excel  -WorksheetName 'RawMembers' @ExportExcelParams
    $Report.MissingMembers | Export-Excel -WorksheetName 'MissingMembers' @ExportExcelParams
    $Report.ValidatedDedupedMembers | Export-Excel -WorksheetName 'ValidatedDedupedMembers' @ExportExcelParams

}