#
# Module manifest for module 'PoshGram'
#
# Generated by: Jake Morrison - @jakemorrison - https://www.techthoughts.info
#
# Generated on: 06/26/18
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'PoshGram.psm1'

    # Version number of this module.
    ModuleVersion     = '3.0.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '277b92bc-0ea9-4659-8f6c-ed5a1dfdfda2'

    # Author of this module
    Author            = 'Jake Morrison'

    # Company or vendor of this module
    CompanyName       = 'TechThoughts'

    # Copyright statement for this module
    Copyright         = '(c) Jake Morrison. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Separate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '6.1.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        @{
            ModuleName    = 'pwshEmojiExplorer';
            ModuleVersion = '0.8.0'
        }
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Get-TelegramStickerPackInfo',
        'Send-TelegramContact',
        'Send-TelegramDice',
        'Send-TelegramLocalAnimation',
        'Send-TelegramLocalAudio',
        'Send-TelegramLocalDocument',
        'Send-TelegramLocalPhoto',
        'Send-TelegramLocalSticker'
        'Send-TelegramLocalVideo',
        'Send-TelegramLocation',
        'Send-TelegramMediaGroup',
        'Send-TelegramPoll',
        'Send-TelegramSticker'
        'Send-TelegramTextMessage',
        'Send-TelegramURLAnimation',
        'Send-TelegramURLAudio',
        'Send-TelegramURLDocument',
        'Send-TelegramURLPhoto',
        'Send-TelegramURLSticker',
        'Send-TelegramURLVideo',
        'Send-TelegramVenue',
        'Test-BotToken'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    #CmdletsToExport   = '*'

    # Variables to export from this module
    #VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    #AliasesToExport   = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @(
                'Animations',
                'Audio',
                'Automation',
                'bot',
                'Contact',
                'Contacts',
                'Coordinates',
                'Dice',
                'Document',
                'Documents',
                'Gif',
                'Gifs',
                'Location',
                'Media',
                'Message',
                'Messaging',
                'Messenger',
                'Notification',
                'Notifications',
                'Notify',
                'Photo',
                'Photos',
                'Pictures',
                'Poll',
                'powershell',
                'powershell-module',
                'PSModule',
                'Send',
                'SM',
                'Sticker',
                'Stickers',
                'Sticker-Pack',
                'telegram',
                'telegram-bot-api',
                'telegramx',
                'Telegram-Sticker'
                'Telegram-Bot',
                'Texting',
                'Venue',
                'Video',
                'Videos'
            )

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/techthoughts2/PoshGram'

            # A URL to an icon representing this module.
            IconUri      = 'https://github.com/techthoughts2/PoshGram/raw/main/media/PoshGram.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/techthoughts2/PoshGram/blob/main/.github/CHANGELOG.md'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
