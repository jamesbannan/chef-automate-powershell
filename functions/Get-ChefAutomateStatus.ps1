<#

.SYNOPSIS
    Returns the status of the nominated Chef Automate server.

.DESCRIPTION
    Returns the status of the nominated Chef Automate server. Does not require an authentication token.

.EXAMPLE
    C:\PS> Get-ChefAutomateStatus -automateServer 'chef-automate.company.com'

.INPUTS
    Takes the DNS-resolvable name of the Chef Automate server (e.g. 'chef-automate' or 'chef-automate.company.com')

.OUTPUTS
    Core server health, configuration mode and FIPS mode of the Chef Automate Server.

#>

function Get-ChefAutomateStatus
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # Chef Automate Server (e.g. chef-automate.company.com)
        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $automateServer
    )

    Begin
    {
    }
    Process
    {
        $apiURL = 'https://' + $automateServer + '/' + 'api'
        $apiStatusURL = $apiURL + '/' + '_status'
        $apiStatus = Invoke-RestMethod -Method Get -Uri $apiStatusURL
        if($apiStatus.status -eq 'pong'){$coreHealth = 'Healthy'}
            else{$coreHealth = 'Unhealthy'}
    }
    End
    {
        $OutputObject = [PSCustomObject]@{
                        'Core Server Health' = $coreHealth
                        'Configuration Mode' = ($apiStatus."configuration mode").substring(0,1).toupper() + ($apiStatus."configuration mode").substring(1).tolower()
                        'FIPS Mode' = ($apiStatus.fips_mode).substring(0,1).toupper() + ($apiStatus.fips_mode).substring(1).tolower()
                        }
        Write-Output -InputObject $OutputObject
    }
}