<#

.SYNOPSIS
    Deletes the nominated compliance profile.

.DESCRIPTION
     Deletes the nominated compliance profile from the Chef Automate compliance store.

.EXAMPLE
    C:\PS> Remove-ChefAutomateComplianceProfile -automateServer 'chef-automate.company.com' -automateOrgName OrgName -automateUser admin -automateUserToken <USER-TOKEN> -complianceName 'ssh'

.INPUTS
    Takes the DNS-resolvable name of the Chef Automate server (e.g. 'chef-automate' or 'chef-automate.company.com'), the Chef Automate Enterprise name (e.g. OrgName), the Chef Automate user who 'owns' the compliance profiles, the user token for authentication (https://YOUR_AUTOMATE_HOST/e/YOUR_AUTOMATE_ENTERPRISE/#/dashboard?token) and the Compliance profile name (e.g. 'ssh')

.OUTPUTS
    Verification that the profile has been deleted.

#>

function Remove-ChefAutomateComplianceProfile
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
        $automateUserToken,

        # Compliance Profile Name e.g. 'ssh')
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $complianceName
    )

    Begin
    {
    }
    Process
    {
        $profileURL = 'https://' + $automateServer + '/compliance/profiles/' + $automateUser + '/' + $complianceName
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("chef-delivery-enterprise", $automateOrgName)
        $headers.Add("chef-delivery-user", $automateUser)
        $headers.Add("chef-delivery-token", $automateUserToken)
        $profile = Invoke-RestMethod -Method Delete -Uri $profileURL -Headers $headers
    }
    End
    {
        $message = 'Deleted compliance profile ' + '"' + $complianceName + '"' + ' from Automate Server ' + '"' + $automateServer + '"'
        Write-Output -InputObject $message
    }
}