function Connect-S4B {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS
    Connects to Microsoft Skype for Business Online service.

    .DESCRIPTION
    Connects to Microsoft Skype for Business Online service.

    .PARAMETER Credential
    PSCredential object containing user credentials.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    PS> Connect-S4B -Credential $Credential

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # testing if module is available
    while (!(Test-MS365Module -Module $ModuleName)) {
        # and install if not available
        #S4B module is not available on https://www.powershellgallery.com - must be installed manually
        Write-Error -Message "SkypeOnlineConnector module is not installed.`nPlease download and install it manually from https://www.microsoft.com/en-us/download/details.aspx?id=39366" -Category NotInstalled
        return
    }

    $ConfigDefaultUPN = $Config['DefaultUserPrincipalName']

    try {
        Import-Module SkypeOnlineConnector
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not import module SkypeOnlineConnector.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    try {
        if ($ConfigDefaultUPN) {
            Write-Verbose -Message "Connecting to S4B with $ConfigDefaultUPN"
            $sfbSession = New-CsOnlineSession $ConfigDefaultUPN
        }
        else {
            Write-Verbose -Message "Connecting to S4B with UPN prompt"
            $sfbSession = New-CsOnlineSession
        }
        Import-PSSession $sfbSession
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not connect to $ServiceItem.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    # set service name into window title if successfully connected
    Set-WindowTitle -Service $ServiceItem
}