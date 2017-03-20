<#

.SYNOPSIS
    Uploads the nominated compliance profile.

.DESCRIPTION
     Uploads the nominated compliance profile from the Chef Automate compliance store.

.EXAMPLE
    C:\PS> Set-ChefAutomateComplianceProfile -automateServer 'chef-automate.company.com' -automateOrgName OrgName -automateUser admin -automateUserToken <USER-TOKEN> -Path 'C:\Temp\WS2012R2 Member Server Security Compliance_DCM.tar.gz'

.INPUTS
    Takes the DNS-resolvable name of the Chef Automate server (e.g. 'chef-automate' or 'chef-automate.company.com'), the Chef Automate Enterprise name (e.g. OrgName), the Chef Automate user who 'owns' the compliance profiles, the user token for authentication (https://YOUR_AUTOMATE_HOST/e/YOUR_AUTOMATE_ENTERPRISE/#/dashboard?token) and the full path to the compliance profile.

.OUTPUTS
    Verification that the profile has been uploaded.

#>

function Set-ChefAutomateComplianceProfile
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

        # Full path to the compliance profile tarball (e.g. C:\Temp\WS2012R2 Member Server Security Compliance_DCM.tar.gz)
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $profilePath
    )

    Begin
    {
    }
    Process
    {
        $profileURL = 'https://' + $automateServer + '/compliance/profiles/' + $automateUser

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("chef-delivery-enterprise", $automateOrgName)
        $headers.Add("chef-delivery-user", $automateUser)
        $headers.Add("chef-delivery-token", $automateUserToken)

        $profile = Invoke-RestMethod -Method Post -Uri $profileURL -Headers $headers -InFile $profilePath -ContentType 'multipart/form-data'
    }
    End
    {
        $message = 'Uploaded compliance profile ' + '"' + $profilePath + '"' + ' to Automate Server ' + '"' + $automateServer + '"'
        Write-Output -InputObject $message
    }
}