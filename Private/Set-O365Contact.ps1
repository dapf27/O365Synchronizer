﻿function Set-O365Contact {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $UserID,
        $User,
        $Contact,
        [string[]] $Properties
    )
    if ($Properties.Count -gt 0) {
        $PropertiesToUpdate = [ordered] @{}
        foreach ($Property in $Properties) {
            $PropertiesToUpdate[$Property] = $User.$Property
        }
        Update-MgUserContact -UserId $UserID -ContactId $Contact.Id @PropertiesToUpdate
    }
}