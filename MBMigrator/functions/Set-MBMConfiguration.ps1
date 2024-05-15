function Set-MBMConfiguration {
    <#
    .SYNOPSIS
        Configure the MBM configuration using key value pairs
    .DESCRIPTION
        Configure the MBM configuration using key value pairs
    .EXAMPLE
        Set-MBMConfiguration -Attribute Key -Value Value
        Adds Key: Value to the MBM Configuration file
    #>
    
    param(
        #
        [string]$Attribute
        ,
        #
        [psobject]$Value
    )

    switch (Test-Path -Path variable:script:MBMConfiguration) {
        $true {
            $Script:MBMConfiguration.$Attribute = $Value
        }
        $false {
            $Script:MBMConfiguration = @{}
            $Script:MBMConfiguration.$Attribute = $Value
        }
    }
}