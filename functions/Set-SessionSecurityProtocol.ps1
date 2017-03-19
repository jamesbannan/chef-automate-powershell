<#

.SYNOPSIS
    Changes the session security protocol to TLS 1.2.

.DESCRIPTION
    Changes the session security protocol to TLS 1.2 for the current PowerShell session only.

.EXAMPLE
    C:\PS> Set-SessionSecurityProtocol

.INPUTS
    None.

.OUTPUTS
    Security protocol for the current session.

#>

function Set-SessionSecurityProtocol
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
    )

    Begin
    {
    }
    Process
    {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }
    End
    {
        $sessionProtocol = [Net.ServicePointManager]::SecurityProtocol
        Write-Output -InputObject $sessionProtocol
    }
}