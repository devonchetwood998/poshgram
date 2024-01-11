<#
.SYNOPSIS
    Sends Telegram audio message via Bot API from URL sourced file
.DESCRIPTION
    Uses Telegram Bot API to send audio message to specified Telegram chat. The file will be sourced from the provided URL and sent to Telegram. Several options can be specified to adjust message parameters. Only works for mp3 files.
.EXAMPLE
    $botToken = 'nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
    $chatID = '-nnnnnnnnn'
    $audioURL = 'https://github.com/techthoughts2/PoshGram/raw/main/test/SourceFiles/Tobu-_-Syndec-Dusk-_NCS-Release_-YouTube.mp3'
    Send-TelegramURLAudio -BotToken $botToken -ChatID $chat -AudioURL $audioURL

    Sends audio message via Telegram API
.EXAMPLE
    $botToken = 'nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
    $chatID = '-nnnnnnnnn'
    $audioURL = 'https://github.com/techthoughts2/PoshGram/raw/main/test/SourceFiles/Tobu-_-Syndec-Dusk-_NCS-Release_-YouTube.mp3'
    $sendTelegramURLAudioSplat = @{
        BotToken            = $botToken
        ChatID              = $chatID
        AudioURL            = $audioURL
        Caption             = 'Check out this audio track'
        ParseMode           = 'MarkdownV2'
        Duration            = 495
        Performer           = 'Metallica'
        Title               = 'Halo On Fire'
        FileName            = 'halo_on_fire.mp3'
        DisableNotification = $true
        ProtectContent      = $true
        Verbose             = $true
    }
    Send-TelegramURLAudio @sendTelegramURLAudioSplat

    Sends audio message via Telegram API
.EXAMPLE
    $botToken = 'nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
    $chatID = '-nnnnnnnnn'
    $audioURL = 'https://github.com/techthoughts2/PoshGram/raw/main/test/SourceFiles/Tobu-_-Syndec-Dusk-_NCS-Release_-YouTube.mp3'
    $sendTelegramURLAudioSplat = @{
        BotToken            = $botToken
        ChatID              = $chatID
        AudioURL            = $audioURL
        Title               = 'Halo On Fire'
        FileName            = 'halo_on_fire.mp3'
        Performer           = 'Metallica'
        Caption             = 'Check out this __awesome__ audio track\.'
        ParseMode           = 'MarkdownV2'
    }
    Send-TelegramURLAudio @sendTelegramURLAudioSplat

    Sends audio message via Telegram API with properly formatted underlined word and escaped special character.
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER AudioURL
    URL path to audio file
.PARAMETER Caption
    Brief title or explanation for media
.PARAMETER Duration
    Duration of the audio in seconds
.PARAMETER ParseMode
    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message. Default is HTML.
.PARAMETER Duration
    Duration of the audio in seconds
.PARAMETER Performer
    Performer
.PARAMETER Title
    Track Name
.PARAMETER FileName
    Original File Name
.PARAMETER DisableNotification
    Send the message silently. Users will receive a notification with no sound.
.PARAMETER ProtectContent
    Protects the contents of the sent message from forwarding and saving
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

    Your audio must be in the .mp3 format.
    Bots can currently send audio files of up to 50 MB in size, this limit may be changed in the future.

    Questions on how to set up a bot, get a token, or get your channel ID?
    Answers on the PoshGram documentation: https://poshgram.readthedocs.io/en/latest/PoshGram-FAQ/
.COMPONENT
    PoshGram
.FUNCTIONALITY
    Parameters              Type                    Required    Description
    chat_id                 Integer or String       Yes         Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    audio                   InputFile or String     Yes         Audio file to send. Pass a file_id as String to send an audio file that exists on the Telegram servers (recommended), pass an HTTP URL as a String for Telegram to get an audio file from the Internet, or upload a new one using multipart/form-data.
    caption                 String                  Optional    Photo caption (may also be used when resending photos by file_id), 0-200 characters
    parse_mode              String                  Optional    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in the media caption.
    duration                Integer                 Optional    Duration of the audio in seconds
    performer               String                  Optional    Performer
    title                   String                  Optional    Track Name
    disable_notification    Boolean                 Optional    Sends the message silently. Users will receive a notification with no sound.
.LINK
    https://poshgram.readthedocs.io/en/latest/Send-TelegramURLAudio
.LINK
    https://core.telegram.org/bots/api#sendaudio
.LINK
    https://core.telegram.org/bots/api#html-style
.LINK
    https://core.telegram.org/bots/api#markdownv2-style
.LINK
    https://core.telegram.org/bots/api
#>
function Send-TelegramURLAudio {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = '#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$BotToken, #you could set a token right here if you wanted

        [Parameter(Mandatory = $true,
            HelpMessage = '-#########')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ChatID, #you could set a Chat ID right here if you wanted

        [Parameter(Mandatory = $true,
            HelpMessage = 'Local path to file you wish to send')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$AudioURL,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Caption for file')]
        [string]$Caption = '', #set to false by default

        [Parameter(Mandatory = $false,
            HelpMessage = 'HTML vs Markdown for message formatting')]
        [ValidateSet('Markdown', 'MarkdownV2', 'HTML')]
        [string]$ParseMode = 'HTML', #set to HTML by default

        [Parameter(Mandatory = $false,
            HelpMessage = 'Duration of the audio in seconds')]
        [int]$Duration,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Performer')]
        [string]$Performer,

        [Parameter(Mandatory = $false,
            HelpMessage = 'TrackName')]
        [string]$Title,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Original File Name')]
        [string]$FileName,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Send the message silently')]
        [switch]$DisableNotification,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Protects the contents of the sent message from forwarding and saving')]
        [switch]$ProtectContent
    )

    Write-Verbose -Message ('Starting: {0}' -f $MyInvocation.Mycommand)

    Write-Verbose -Message 'Verifying URL leads to supported audio extension...'
    $fileTypeEval = Test-URLExtension -URL $AudioURL -Type Audio
    if ($fileTypeEval -eq $false) {
        throw ('The specified audio URL: {0} does not contain a supported extension.' -f $AudioURL)
    } #if_audioExtension
    else {
        Write-Verbose -Message 'Extension supported.'
    } #else_audioExtension

    Write-Verbose -Message 'Verifying URL presence and file size...'
    $fileSizeEval = Test-URLFileSize -URL $AudioURL
    if ($fileSizeEval -eq $false) {
        throw 'File size does not meet Telegram requirements'
    } #if_audioSize
    else {
        Write-Verbose -Message 'File size verified.'
    } #else_audioSize

    $payload = @{
        chat_id              = $ChatID
        audio                = $AudioURL
        caption              = $Caption
        parse_mode           = $ParseMode
        duration             = $Duration
        performer            = $Performer
        title                = $Title
        file_name            = $FileName
        disable_notification = $DisableNotification.IsPresent
        protect_content      = $ProtectContent.IsPresent
    } #payload

    $uri = 'https://api.telegram.org/bot{0}/sendAudio' -f $BotToken
    Write-Debug -Message ('Base URI: {0}' -f $uri)

    Write-Verbose -Message 'Sending audio...'
    $invokeRestMethodSplat = @{
        Uri         = $uri
        Body        = (ConvertTo-Json -Compress -InputObject $payload)
        ErrorAction = 'Stop'
        ContentType = 'application/json'
        Method      = 'Post'
    }
    try {
        Write-Verbose -Message 'Sending message...'
        $results = Invoke-RestMethod @invokeRestMethodSplat
    } #try_messageSend
    catch {
        Write-Warning -Message 'An error was encountered sending the Telegram message:'
        Write-Error $_
        if ($_.ErrorDetails) {
            $results = $_.ErrorDetails | ConvertFrom-Json -ErrorAction SilentlyContinue
        }
        else {
            throw $_
        }
    } #catch_messageSend

    return $results
} #function_Send-TelegramURLAudio
