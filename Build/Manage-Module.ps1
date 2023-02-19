Clear-Host
Import-Module "C:\Support\GitHub\PSPublishModule\PSPublishModule.psm1" -Force

$Configuration = @{
    Information = @{
        ModuleName        = 'O365Synchronizer'
        DirectoryProjects = 'C:\Support\GitHub'

        Manifest          = @{
            # Version number of this module.
            ModuleVersion              = '0.0.X'
            # Supported PSEditions
            CompatiblePSEditions       = @('Desktop', 'Core')

            PowerShellVersion          = '5.1'
            # ID used to uniquely identify this module
            GUID                       = '81e907a0-a475-4d6a-a80d-20e9f08ad6b7'
            # Author of this module
            Author                     = 'Przemyslaw Klys'
            # Company or vendor of this module
            CompanyName                = 'Evotec'
            # Copyright statement for this module
            Copyright                  = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
            # Description of the functionality provided by this module
            Description                = "This module allows to synchronize users to/from Office 365."
            # Minimum version of the Windows PowerShell engine required by this module
            Tags                       = 'windows'
            # A URL to the main website for this project.
            ProjectUri                 = 'https://github.com/EvotecIT/O365Synchronizer'

            # A URL to an icon representing this module.
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2023/01/O365Synchronizer.png'

            RequiredModules            = @(
                @{ ModuleName = 'PSSharedGoods'; ModuleVersion = "Latest"; Guid = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe' }
                @{ ModuleName = 'Mailozaurr'; ModuleVersion = "Latest"; Guid = '2b0ea9f1-3ff1-4300-b939-106d5da608fa' }
                @{ ModuleName = 'PSWriteHTML'; ModuleVersion = "Latest"; Guid = 'a7bdf640-f5cb-4acf-9de0-365b322d245c' }
                @{ ModuleName = 'PSWriteColor'; ModuleVersion = "Latest"; Guid = '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f' }
                @{ ModuleName = 'Microsoft.Graph.Identity.SignIns'; ModuleVersion = 'Latest'; Guid = '60f889fa-f873-43ad-b7d3-b7fc1273a44f' }
                @{ ModuleName = 'Microsoft.Graph.Identity.DirectoryManagement'; ModuleVersion = 'Latest'; Guid = 'c767240d-585c-42cb-bb2f-6e76e6d639d4' }
                @{ ModuleName = 'Microsoft.Graph.Users'; ModuleVersion = 'Latest'; Guid = '71150504-37a3-48c6-82c7-7a00a12168db' }
                @{ ModuleName = 'Microsoft.Graph.PersonalContacts'; ModuleVersion = 'Latest'; Guid = 'a53e24d0-43dd-43ec-950e-7ac40ea986fc' }
            )
            ExternalModuleDependencies = @(
                # "ActiveDirectory"
            )
        }
    }
    Options     = @{
        Merge             = @{
            Sort           = 'None'
            FormatCodePSM1 = @{
                Enabled           = $true
                RemoveComments    = $false
                FormatterSettings = @{
                    IncludeRules = @(
                        'PSPlaceOpenBrace',
                        'PSPlaceCloseBrace',
                        'PSUseConsistentWhitespace',
                        'PSUseConsistentIndentation',
                        'PSAlignAssignmentStatement',
                        'PSUseCorrectCasing'
                    )

                    Rules        = @{
                        PSPlaceOpenBrace           = @{
                            Enable             = $true
                            OnSameLine         = $true
                            NewLineAfter       = $true
                            IgnoreOneLineBlock = $true
                        }

                        PSPlaceCloseBrace          = @{
                            Enable             = $true
                            NewLineAfter       = $false
                            IgnoreOneLineBlock = $true
                            NoEmptyLineBefore  = $false
                        }

                        PSUseConsistentIndentation = @{
                            Enable              = $true
                            Kind                = 'space'
                            PipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
                            IndentationSize     = 4
                        }

                        PSUseConsistentWhitespace  = @{
                            Enable          = $true
                            CheckInnerBrace = $true
                            CheckOpenBrace  = $true
                            CheckOpenParen  = $true
                            CheckOperator   = $true
                            CheckPipe       = $true
                            CheckSeparator  = $true
                        }

                        PSAlignAssignmentStatement = @{
                            Enable         = $true
                            CheckHashtable = $true
                        }

                        PSUseCorrectCasing         = @{
                            Enable = $true
                        }
                    }
                }
            }
            FormatCodePSD1 = @{
                Enabled        = $true
                RemoveComments = $false
            }
            Integrate      = @{
                ApprovedModules = @('PSSharedGoods', 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword', 'PSPublishModule')
            }
        }
        Standard          = @{
            FormatCodePSM1 = @{

            }
            FormatCodePSD1 = @{
                Enabled = $true
                #RemoveComments = $true
            }
        }
        ImportModules     = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PowerShellGallery = @{
            ApiKey   = 'C:\Support\Important\PowerShellGalleryAPI.txt'
            FromFile = $true
        }
        GitHub            = @{
            ApiKey   = 'C:\Support\Important\GithubAPI.txt'
            FromFile = $true
            UserName = 'EvotecIT'
            #RepositoryName = 'PSWriteHTML'
        }
        Documentation     = @{
            Path       = 'Docs'
            PathReadme = 'Docs\Readme.md'
        }
    }
    Steps       = @{
        BuildModule        = @{  # requires Enable to be on to process all of that
            Enable           = $true
            DeleteBefore     = $false
            Merge            = $true
            MergeMissing     = $true
            SignMerged       = $true
            Releases         = $true
            ReleasesUnpacked = $true
            RefreshPSD1Only  = $false
        }
        BuildDocumentation = $true
        ImportModules      = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PublishModule      = @{  # requires Enable to be on to process all of that
            Enabled      = $false
            Prerelease   = ''
            RequireForce = $false
            GitHub       = $false
        }
    }
}

New-PrepareModule -Configuration $Configuration