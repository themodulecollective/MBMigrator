Function Export-Credential {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$Username
        ,
        [parameter(Mandatory)]
        [ValidateScript({Test-Path -Path $_ -PathType Container})]
        [string]$OutputFolderPath
        ,
        [parameter()]
        [ValidateLength(0,5)]
        [string]$Prefix
    )

    $getCredParams = @{
        Message = "Getting $Username Credential for Export" 
        Username = $Username
    }

    try {
        $credential  =  Get-Credential @getCredParams    
    }
    catch {
        throw ("Unable to get the credential for $Username")
    }

    $newGuid = New-Guid
    $filename = [string]$(switch([string]::IsNullOrWhiteSpace($Prefix)) {$false {$Prefix + '-'}}) + $newGuid.guid + '.xml'
    $filepath = Join-Path -Path $OutputFolderPath -ChildPath $filename

    Write-Information -MessageData "Exporting Credential for $username to File $filepath"

    $credential | Export-Clixml -Path $filepath 
}