function Update-MBMWavePlanning {
    <#
    .SYNOPSIS
        Imports WavePlanning.xlsx into the Migration Database
    .DESCRIPTION
        Imports WavePlanning.xlsx into the Migration Database
    .EXAMPLE
        Update-MBMWavePlanning -InputFolderPath "C:\Users\Username\Documents\WavePlanning.xlsx"
        Imports WavePlanning.xlsx from the Documents folder into the Migration Database
    #>

    [cmdletbinding()]
    param(
        #
        [parameter(Mandatory)]
        $InputFolderPath
    )

    Import-Module ImportExcel
    Import-Module dbatools

    $Configuration = Get-MBMConfiguration
    $dbParams = @{
        SqlInstance = $Configuration.SQLInstance
        Database    = $Configuration.Database
    }

    $FilePath = Join-Path -Path $InputFolderPath -ChildPath 'WavePlanning.xlsx'

    switch (Test-Path -PathType Leaf -Path $FilePath) {
        $false {
            throw("Provided Folder Path $InputFolderPath does not contain file WavePlanning.xlsx")
        }
        $true {
            foreach ($s in @('WavePlan', 'WaveAssignments', 'WaveExceptions', 'SpecialHandling')) {

                Write-Information -MessageData "Processing $s"

                $data = Import-Excel -Path $(Join-Path -Path $InputFolderPath -ChildPath WavePlanning.xlsx) -WorksheetName $s -ErrorAction Stop

                $wDTParams = @{
                    Table    = $s
                    Truncate = $true
                    Confirm  = $false
                }

                if ($null -eq $(Get-DbaDbTable @dbParams -Table $s)) {
                    $wDTParams.AutoCreateTable = $true
                }

                $data | ConvertTo-DbaDataTable | Write-DbaDataTable @dbParams @wDTParams
            }
        }
    }


}