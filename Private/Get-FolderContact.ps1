function Get-FolderContact {
  [cmdletbinding()]
  param (
    [parameter(Mandatory)][object]$ContactFolder,
    [string]$DisplayName
  )
  try {
    $contactList = Get-MgUserContactFolderContact -UserId $ContactFolder.UserId -ContactFolderId $contactFolder.Id -All
    if (-not $contactList) {
      Write-Color -Text '[i] ', 'Processing ', 'Not able to find contacts in folder' -Color Yellow, White, Cyan
      return
    } else {
      if ($DisplayName) {
        $contactList = $contactList | Where-Object { $_.displayName -eq $DisplayName }
      }
      $contactReturnObject = @()
      $contactList | ForEach-Object {
        $contactReturnObject += [pscustomobject]@{
          businessPhones = $_.businessPhones
          displayname    = $_.displayName
          givenName      = $_.givenName
          surname        = $_.surname
          jobTitle       = $_.jobTitle
          department     = $_.department
          # homePhones     = [array]$_.homePhones
          emailAddresses = $_.emailAddresses
          id             = $_.id
        }
      }
      Write-Color -Text '[i] ', 'Processing ', "Found $($contactReturnObject.count) contacts in the folder" -Color Yellow, White, Cyan
      return $contactReturnObject
    }
  } catch {
    throw
  }
}
