<#

.SYNOPSIS
    Returns the compliance profiles for a nominated owner.

.DESCRIPTION
    Returns the compliance profiles for a nominated owner from the Chef Automate compliance store.

.EXAMPLE
    C:\PS> Get-ChefAutomateComplianceProfiles -automateServer 'chef-automate.company.com' -automateOrgName OrgName -automateUser admin -automateUserToken <USER-TOKEN>

.INPUTS
    Takes the DNS-resolvable name of the Chef Automate server (e.g. 'chef-automate' or 'chef-automate.company.com'), the Chef Automate Enterprise name (e.g. OrgName), the Chef Automate user who 'owns' the compliance profiles and the user token for authentication (https://YOUR_AUTOMATE_HOST/e/YOUR_AUTOMATE_ENTERPRISE/#/dashboard?token)

.OUTPUTS
    PowerShell array of all compliance profiles on the Chef Automate server owned by the nominated user.

#>

function Get-ChefAutomateComplianceProfiles
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Chef Automate Server (e.g. chef-automate.company.com)
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $automateServer,

        # Chef Automate Enterprise Name (e.g. MyOrg)
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $automateOrgName,

        # Chef Automate User (e.g. 'john')
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $automateUser,

        # Chef Automate USer Token (https://YOUR_AUTOMATE_HOST/e/YOUR_AUTOMATE_ENTERPRISE/#/dashboard?token)
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $automateUserToken
    )

    Begin
    {
    }
    Process
    {
        $complianceURL = 'https://' + $automateServer + '/compliance/profiles/' + $automateUser
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("chef-delivery-enterprise", $automateOrgName)
        $headers.Add("chef-delivery-user", $automateUser)
        $headers.Add("chef-delivery-token", $automateUserToken)
        $profiles = Invoke-RestMethod -Method Get -Uri $complianceURL -Headers $headers

        $profileNames = $($profiles | Get-Member -MemberType *Property).Name
        $names = @()
        foreach($profileName in $profileNames){
            $name = New-Object PSObject
            $name | Add-Member -MemberType NoteProperty -Name 'Name' -Value $profileName
            $names += $name
        }

    }
    End
    {
        foreach($name in $names){
            Write-Output -InputObject $profiles.($name.Name)
        }
    }
}