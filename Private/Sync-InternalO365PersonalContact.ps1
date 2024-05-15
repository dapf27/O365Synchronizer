function Sync-InternalO365PersonalContact {
  [cmdletBinding(SupportsShouldProcess)]
  param(
    [string] $UserId,
    [ValidateSet('Member', 'Guest', 'Contact')][string[]] $MemberTypes,
    [switch] $RequireEmailAddress,
    [string] $GuidPrefix,
    [string] $ContactFolderName,
    [System.Collections.IDictionary] $ExistingUsers,
    [System.Collections.IDictionary] $ExistingContacts
  )
  $ListActions = [System.Collections.Generic.List[object]]::new()
  # $ToPotentiallyRemove = [System.Collections.Generic.List[object]]::new()
  # foreach ($ContactID in $ExistingContacts.Keys) {
  #     $Contact = $ExistingContacts[$ContactID]
  #     $Entry = $Contact.FileAs
  #     if ($ExistingUsers[$Entry]) {
  #         $User = $ExistingUsers[$Entry]
  #         if ($User.Type -notin $MemberTypes) {
  #             Write-Color -Text "[i] ", "Skipping ", $User.DisplayName, " because they are not a type: ", $($MemberTypes -join ', ') -Color Yellow, White, DarkYellow, White, DarkYellow
  #             $ToPotentiallyRemove.Add($ExistingContacts[$ContactID])
  #         }
  #     } else {
  #         Write-Color -Text "[i] ", "Skipping ", $Contact.DisplayName, " because user does not exist" -Color Yellow, White, DarkYellow, White, DarkYellow
  #         #$ToPotentiallyRemove.Add($ExistingContacts[$ContactID])
  #     }
  # }

  # Get/create contact folder
  try {
    $contactFolder = Get-ContactFolder -UserId $UserId -ContactFolderName $ContactFolderName
    if ($contactFolder) {
      Write-Color -Text '[i] ', 'Processing ', "Found folder $($ContactFolderName) for $($UserId)" -Color Yellow, White, Cyan
    } else {
      try {
        $contactFolder = New-ContactFolder -UserId $UserId -ContactFolderName $ContactFolderName
        Write-Color -Text '[i] ', 'Processing ', "Created folder $($ContactFolderName) for $($UserId)" -Color Yellow, White, Cyan
      } catch {
        throw 'Something went wrong creating the contact folder'
      }
    }
    if (-not $contactFolder) {
      throw 'No contact folder found or not able to create one'
    }
  } catch {
    throw "Something went wrong getting the contact folder for $($UserId)"
  }

  <#
  # get contacts in that folder
  try {
    $contactsInFolder = Get-FolderContact -ContactFolder $contactFolder
  } catch {
    throw "Failed to create contact folder $($ContactFolderName) in mailbox $($UserId)"
  }

  if ($contactsInFolder) {
    $removeContacts = $contactsInFolder | Where-Object { $_.displayName -notin $ContactList.displayName }
    # Remove contacts that have duplicate displayNames. This is the only way to correctly sync
    # contacts when using displayName as the "primary key"
    $removeContacts += $contactsInFolder | Group-Object displayName | Where-Object { $_.Count -gt 1 } | ForEach-Object { $_.Group }

    if ($removeContacts) {
      foreach ($contact in $removeContacts) {
        try {
          Remove-FolderContact -Contact $contact -ContactFolder $contactFolder | Out-Null
          Write-LogEvent -Level Info -Message "Removed contact $($contact.displayName)"
        } catch {
          Write-LogEvent -Level Error -Message "Failed to remove contact $($contact.displayName)"
        }
      }
    }

    # Get contacts in that folder again (after we've possibly removed some of them)
    try {
      $contactsInFolder = Get-FolderContact -ContactFolder $contactFolder
    } catch {
      throw "Failed to create contact folder $($ContactFolderName) in mailbox $($Mailbox)"
    }
  }
  #>

  foreach ($UsersInternalID in $ExistingUsers.Keys) {
    $User = $ExistingUsers[$UsersInternalID]
    if ($User.Mail) {
      Write-Color -Text '[i] ', 'Processing ', $User.DisplayName, ' / ', $User.Mail -Color Yellow, White, Cyan, White, Cyan
    } else {
      Write-Color -Text '[i] ', 'Processing ', $User.DisplayName -Color Yellow, White, Cyan
    }
    $Entry = $User.Id
    $Contact = $ExistingContacts[$Entry]

    # lets check if user is a member or guest
    # if ($User.Type -notin $MemberTypes) {
    #     Write-Color -Text "[i] ", "Skipping ", $User.DisplayName, " because they are not a ", $($MemberTypes -join ', ') -Color Yellow, White, DarkYellow, White, DarkYellow
    #     if ($Contact) {
    #         $ToPotentiallyRemove.Add($ExistingContacts[$Entry])
    #     }
    #     continue
    # }
    if ($Contact) {
      # Contact exists, lets check if we need to update it
      $OutputObject = Set-O365InternalContact -UserID $UserId -User $User -Contact $Contact
      $ListActions.Add($OutputObject)
    } else {
      # Contact does not exist, lets create it
      $OutputObject = New-O365InternalContact -UserId $UserId -User $User -GuidPrefix $GuidPrefix -RequireEmailAddress:$RequireEmailAddress -ContactFolderId $contactFolder.Id
      $ListActions.Add($OutputObject)
    }
  }
  # now lets remove any contacts that are not required or filtered out
  $RemoveActions = Remove-O365InternalContact -ExistingUsers $ExistingUsers -ExistingContacts $ExistingContacts -UserId $UserId
  foreach ($Remove in $RemoveActions) {
    $ListActions.Add($Remove)
  }
  $ListActions
}
