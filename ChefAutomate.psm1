#
# Code lifted from existing project:
# https://github.com/poshsecurity/AzurePublicIPAddresses/blob/master/AzurePublicIPAddresses.psm1
# 


#get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path -Path $mypath\functions\*.ps1 | ForEach-Object -Process {
    . $_.ProviderPath
    $Function = ((Split-Path -Path $_.ProviderPath -Leaf).Split('.')[0])
    Export-ModuleMember -Function $Function
}
