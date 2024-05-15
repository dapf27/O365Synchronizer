function New-ContactFolder {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [string]$UserId,
    [string]$ContactFolderName
  )
  try {
    Write-Color -Text '[i] ', 'Processing ', "Creating new folder $ContactFolderName" -Color Yellow, White, Cyan
    $contactFolderBody = @{
      displayName = $ContactFolderName
    }
    $contactFolder = New-MgUserContactFolder -UserId $UserId -BodyParameter $contactFolderBody
    Write-Color -Text '[i] ', 'Processing ', 'Created folder' -Color Yellow, White, Cyan
    $contactFolder | Add-Member -MemberType NoteProperty -Name 'UserId' -Value $UserId
    # because graph is graph...
    Write-Color -Text '[i] ', 'Processing ', "Sleeping a few seconds and adding $UserId to return object" -Color Yellow, White, Cyan
    Start-Sleep (Get-Random -Minimum 5 -Maximum 15)
    return $contactFolder | Select-Object -ExcludeProperty '@odata.context'
  } catch {
    throw
  }
}
