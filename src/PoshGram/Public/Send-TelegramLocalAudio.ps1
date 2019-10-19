<#
.Synopsis
    Sends Telegram audio message via Bot API from locally sourced file
.DESCRIPTION
    Uses Telegram Bot API to send audio message to specified Telegram chat. The audio will be sourced from the local device and uploaded to telegram. Several options can be specified to adjust message parameters. Telegram only supports mp3 audio.
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $audio = "C:\audio\halo_on_fire.mp3"
    Send-TelegramLocalAudio -BotToken $botToken -ChatID $chat -Audio $audio

    Sends audio message via Telegram API
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $audio = "C:\audio\halo_on_fire.mp3"
    Send-TelegramLocalAudio `
        -BotToken $botToken `
        -ChatID $chat `
        -Audio $audio `
        -Caption "Check out this audio track" `
        -ParseMode Markdown `
        -Duration 495 `
        -Performer "Metallica" `
        -Title "Halo On Fire" `
        -DisableNotification `
        -Verbose

    Sends audio message via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER Audio
    Local path to audio file
.PARAMETER Caption
    Brief title or explanation for media
.PARAMETER Duration
    Duration of the audio in seconds
.PARAMETER ParseMode
    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message. Default is Markdown.
.PARAMETER Duration
    Duration of the audio in seconds
.PARAMETER Performer
    Performer
.PARAMETER Title
    Track Name
.PARAMETER DisableNotification
    Send the message silently. Users will receive a notification with no sound.
.OUTPUTS
    System.Management.Automation.PSCustomObject (if successful)
    System.Boolean (on failure)
.NOTES
    Author: Jake Morrison - @jakemorrison - https://techthoughts.info/
    This works with PowerShell Version: 6.1+

    Your audio must be in the .mp3 format.
    Bots can currently send audio files of up to 50 MB in size, this limit may be changed in the future.

    For a description of the Bot API, see this page: https://core.telegram.org/bots/api
    How do I get my channel ID? Use the getidsbot https://telegram.me/getidsbot  -or-  Use the Telegram web client and copy the channel ID in the address
    How do I set up a bot and get a token? Use the BotFather https://t.me/BotFather
.COMPONENT
    PoshGram - https://github.com/techthoughts2/PoshGram
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
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramLocalAudio.md
.LINK
    https://core.telegram.org/bots/api#sendaudio
#>
function Send-TelegramLocalAudio {
    [CmdletBinding()]
    Param
    (
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
        [string]$Audio,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Caption for file')]
        [string]$Caption = "", #set to false by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'HTML vs Markdown for message formatting')]
        [ValidateSet("Markdown", "HTML")]
        [string]$ParseMode = "Markdown", #set to Markdown by default
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
            HelpMessage = 'Send the message silently')]
        [switch]$DisableNotification
    )
    #------------------------------------------------------------------------
    $results = $true #assume the best
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying presence of file..."
    if (!(Test-Path -Path $Audio)) {
        Write-Warning "The specified file: $Audio was not found."
        $results = $false
        return $results
    }#if_testPath
    else {
        Write-Verbose -Message "Path verified."
    }#else_testPath
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying extension type..."
    $fileTypeEval = Test-FileExtension -FilePath $Audio -Type Audio
    if ($fileTypeEval -eq $false) {
        $results = $false
        return $results
    }#if_videoExtension
    else {
        Write-Verbose -Message "Extension supported."
    }#else_videoExtension
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying file size..."
    $fileSizeEval = Test-FileSize -Path $Audio
    if ($fileSizeEval -eq $false) {
        $results = $false
        return $results
    }#if_videoSize
    else {
        Write-Verbose -Message "File size verified."
    }#else_videoSize
    #------------------------------------------------------------------------
    try {
        $fileObject = Get-Item $Audio -ErrorAction Stop
    }#try_Get-ItemVideo
    catch {
        Write-Warning "The specified file could not be interpreted properly."
        $results = $false
        return $results
    }#catch_Get-ItemVideo
    #------------------------------------------------------------------------
    $uri = "https://api.telegram.org/bot$BotToken/sendAudio"
    $Form = @{
        chat_id              = $ChatID
        audio                = $fileObject
        caption              = $Caption
        parse_mode           = $ParseMode
        duration             = $Duration
        performer            = $Performer
        title                = $Title
        disable_notification = $DisableNotification.IsPresent
    }#form
    #------------------------------------------------------------------------
    $invokeRestMethodSplat = @{
        Uri         = $Uri
        ErrorAction = 'Stop'
        Form        = $Form
        Method      = 'Post'
    }
    #------------------------------------------------------------------------
    try {
        $results = Invoke-RestMethod @invokeRestMethodSplat
    }#try_messageSend
    catch {
        Write-Warning "An error was encountered sending the Telegram audio message:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramLocalAudio