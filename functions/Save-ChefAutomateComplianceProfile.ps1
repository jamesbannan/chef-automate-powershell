<#

.SYNOPSIS
    Downloads the nominated compliance profile as a tarball.

.DESCRIPTION
    Downloads the nominated compliance profile as a tarball from the Chef Automate compliance store and saves it to a specific path or the current path.

.EXAMPLE
    C:\PS> Save-ChefAutomateComplianceProfiles -automateServer 'chef-automate.company.com' -automateOrgName OrgName -automateUser admin -automateUserToken <USER-TOKEN> -complianceName 'ssh'

.EXAMPLE
    C:\PS> Save-ChefAutomateComplianceProfiles -automateServer 'chef-automate.company.com' -automateOrgName OrgName -automateUser admin -automateUserToken <USER-TOKEN> -complianceName 'ssh' -profilePath 'C:\Temp'

.INPUTS
    Takes the DNS-resolvable name of the Chef Automate server (e.g. 'chef-automate' or 'chef-automate.company.com'), the Chef Automate Enterprise name (e.g. OrgName), the Chef Automate user who 'owns' the compliance profiles, the user token for authentication (https://YOUR_AUTOMATE_HOST/e/YOUR_AUTOMATE_ENTERPRISE/#/dashboard?token), the Compliance profile name (e.g. 'ssh') and the local path to which to save the tarball.

.OUTPUTS
    Tarball containing the specified compliance profile.

#>

function Save-ChefAutomateComplianceProfile
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
        $complianceName,

        # Local path for Compliance Profile e.g. 'C:\Temp')
        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $profilePath
    )

    Begin
    {
    }
    Process
    {
        $profileURL = 'https://' + $automateServer + '/compliance/profiles/' + $automateUser + '/' + $complianceName + '/tar'
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("chef-delivery-enterprise", $automateOrgName)
        $headers.Add("chef-delivery-user", $automateUser)
        $headers.Add("chef-delivery-token", $automateUserToken)
        $fileName = $complianceName +'-' + (Get-Date -Format yyyyMMddHHMMss) + '.tar.gz'

        if($profilePath -eq $null){$profilePath = (Get-Item -Path ".\" -Verbose).FullName}

        $localProfile = $profilePath + '\' + $fileName
        Invoke-RestMethod -Method Get -Uri $profileURL -Headers $headers -OutFile $localProfile
    }
    End
    {
        $message = 'Downloaded compliance profile' + ' ' + '"' + $complianceName + '"' + ' to ' + $localProfile
        Write-Output -InputObject $message
    }
}