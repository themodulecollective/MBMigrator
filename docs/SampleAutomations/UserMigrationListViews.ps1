$fields = @('WDEmployeeID','SourceDisplayName','TargetDisplayName','SourceMail','TargetMail','MigrationStatus','AssignedWave','TargetDate','AssignmentType','SourceADEnabled','SourceLitigationHoldEnabled','SourceMailboxGB','SourceMailboxDeletedGB','SourceMailboxItemCount','SourceDriveGB','Country','Location','LocationCountry','Region','SourceEntraLastSigninTime','TargetEntraLastSigninTime','SourceMobileDevices','msExchExtensionAttribute16','msExchExtensionAttribute20','msExchExtensionAttribute21','ManagerEmail','SpecialHandlingNotes','MatchScenario','SourceDriveURL','TargetDriveURL','Modified','Editor','SourceMFARegistered','TargetMFARegistered','FlyOneDrive','FlyTeamsChat','FlyExchange')

$viewParams = @{
    List = 'User Migration List'
    Title = "01 Wave 1"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">1</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "02 Wave 2"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">2</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "03 Wave 3"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">3</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "04 Wave 4"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">4</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "05 Wave 5"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">5</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "06 Wave 6"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">6</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "07 Wave 7"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">7</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "08 Wave 8"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">8</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "09 Wave 9"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">9</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "10 Wave 10"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">10</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "11 Wave 11"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">11</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "12 Wave 12"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">12</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "13 Wave 13"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "91 Temporary Issue"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">91</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "92 Disabled User"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">92</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "93 MFA Registration"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">93</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "94 Financial-EndOfPeriod"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">94</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "99 Never Migrate"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">99</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "14 Wave 14"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "15 Wave 15"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "16 Wave 16"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "11.1 Wave 11.1"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
List = 'User Migration List'
Title = "17 Wave 17"
#query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
Fields = $fields
RowLimit = 900
}

Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
Start-Sleep -Seconds 3
Add-PnPView @viewParams

$viewParams = @{
    List = 'User Migration List'
    Title = "15.1 Wave 15.1"
    #query = '<Query><Where><Eq><FieldRef Name="AssignedWave" /><Value Type="Number">13</Value></Eq></Where><Aggregations Value="On"><FieldRef Name="AssignedWave" Type="COUNT" /></Aggregations><GroupBy><FieldRef Name="AssignedWave" /></GroupBy><OrderBy><FieldRef Name="SourceMail" Ascending="TRUE" /></OrderBy></Query>'
    Fields = $fields
    RowLimit = 900
    }

    Remove-PnPView -List $viewParams.List -Identity $viewParams.Title -Force
    Start-Sleep -Seconds 3
    Add-PnPView @viewParams