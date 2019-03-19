#
# Module manifest for module 'PoshGram'
#
# Generated by: Jake Morrison - @jakemorrison - http://techthoughts.info
#
# Generated on: 06/26/18
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'PoshGram.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.1'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = '277b92bc-0ea9-4659-8f6c-ed5a1dfdfda2'

    # Author of this module
    Author            = 'Jake Morrison'

    # Company or vendor of this module
    CompanyName       = 'Tech Thoughts'

    # Copyright statement for this module
    Copyright         = '(c) 2019 Jake Morrison. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'PoshGram provides functionality to send various message types to a specified Telegram chat via the Telegram Bot API. Seperate PowerShell functions are used for each message type. Checks are included to ensure that file extensions, and file size restrictions are adhered to based on Telegram requirements.'

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
    # RequiredModules = @()

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
        'Test-BotToken',
        'Send-TelegramTextMessage',
        'Send-TelegramLocalPhoto',
        'Send-TelegramURLPhoto',
        'Send-TelegramLocalDocument',
        'Send-TelegramURLDocument',
        'Send-TelegramLocalVideo',
        'Send-TelegramURLVideo',
        'Send-TelegramLocalAudio',
        'Send-TelegramURLAudio',
        'Send-TelegramLocalAnimation',
        'Send-TelegramURLAnimation',
        'Send-TelegramLocation',
        'Send-TelegramMediaGroup'
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
            Tags = @(
                'telegram',
                'telegramx',
                'bot',
                'telegram-bot-api',
                'powershell',
                'powershell-module',
                'PSModule',
                'Messenger',
                'Message',
                'Notification',
                'Notifications',
                'Notify',
                'Send',
                'Messaging',
                'Automation',
                'Photo',
                'Photos',
                'Pictures',
                'Video',
                'Videos',
                'Gif',
                'Gifs',
                'Animations',
                'Location',
                'Coordinates',
                'Media',
                'Documents',
                'Audio',
                'SMS'
            )

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/techthoughts2/PoshGram'

            # A URL to an icon representing this module.
            IconUri      = 'https://github.com/techthoughts2/PoshGram/raw/master/media/PoshGram.png'

            # ReleaseNotes of this module
            ReleaseNotes = '
1.0.1 :
    Addressed bug where certain UTF-8 characters would fail to send properly in Send-TelegramTextMessage
1.0.0 :
    Addressed bug in Send-TelegramTextMessage that wasnt handling underscores
    Added code to support AWS Codebuild
0.9.0 :
    Restructured module for CI/CD Workflow
    Added Invoke-Build capabilities to module
    Added Animation functionality:
        Send-TelegramLocalAnimation
        Send-TelegramURLAnimation
    Added location functionality:
        Send-TelegramLocation
    Added multi-media functionality:
        Send-TelegramMediaGroup
    Consolidated private support functions
    Code Logic improvements
0.8.4 Added IconURI to manifest
0.8.3 Initial beta release.
'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}