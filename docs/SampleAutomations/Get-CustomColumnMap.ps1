function Get-CustomColumnMap
{
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [ValidateSet(
            'PersonDetails','ManagerAssistant'
        )]
        $TableType
    )


    switch ($TableType)
    {
        'PersonDetails'
        {
            @(
                $(@(
                    'AssociateNumber'
                    ,'EmployeeID'
                    ,'PreferredLastName'
                    ,'PreferredFirstName'
                    ,'StatusCode'
                    ,'CompanyCode'
                    ,'CompanyDescription'
                    ,'DepartmentDescription'
                    ,'PositionTitle'
                    ,'CostCenterCode'
                    ,'CostCenterDescription'
                    ,'LocationCode'
                    ,'OrgUnitShortName'
                    ,'BusinessUnit'
                    ,'Department'
                    ,'Reviewer1'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 64
                                Nullable  = $true
                            }
                        })))
        }
        'ManagerAssistant'
        {
            @(
                $(@(
                    'Alias'
                    ,'Relationship'
                    ,'AssistantAlias'
                    ).foreach(
                        {
                            @{
                                Name      = $_
                                Type      = 'nvarchar'
                                MaxLength = 64
                                Nullable  = $true
                            }
                        })))
        }
    }
}