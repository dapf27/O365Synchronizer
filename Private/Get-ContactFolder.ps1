function Get-ContactFolder {
  param (
    [CmdletBinding()]
    [parameter(Mandatory)][string] $UserId,
    [string] $ContactFolderName
  )
  try {
    Write-Color -Text '[i] ', 'Processing ', "Getting folder $ContactFolderName" -Color Yellow, White, Cyan
    $folderList = Get-MgUserContactFolder -UserId $UserId -Filter "displayName eq '$ContactFolderName'"
    if (-not $ContactFolderName) {
      Write-Color -Text '[i] ', 'Processing ', 'Default contacts folder is querried' -Color Yellow, White, Cyan
      $folderList = $folderList | Where-Object { $_.wellKnownName }
    } else {
      # if ContactFolderName is not filled in
      $folderList = $folderList | Where-Object { $_.displayName -eq $ContactFolderName }
    }
    if (-not $folderList) {
      Write-Color -Text '[i] ', 'Processing ', "Not able to find the contact folder $ContactFolderName for $UserId" -Color Yellow, White, Cyan
      return $false | Out-Null
    }

    # If there are multiple contact folders present with the same name,
    # we try to delete every one of them, return false and re-create the sync
    # folder with the name $ContactFolderName later
    <#
    if ($folderList.Count -gt 1) {
      ForEach ($folderEntry in $folderList) {
        Delete-ContactFolder -Mailbox $UserId -ContactFolder $folderEntry
      }
      Write-Color -Text '[i] ', 'Processing ', 'Sleeping a few seconds to wait for API update' -Color Yellow, White, Cyan
      Start-Sleep (Get-Random -Minimum 5 -Maximum 15)
      return $false | Out-Null
    }
    #>

    $folderList | Add-Member -MemberType NoteProperty -Name 'UserId' -Value $UserId
    return $folderList
  } catch {
    throw
  }
}
