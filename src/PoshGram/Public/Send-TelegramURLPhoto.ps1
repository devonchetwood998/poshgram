<#
.Synopsis
    Sends Telegram photo message via Bot API from URL sourced photo image
.DESCRIPTION
    Uses Telegram Bot API to send photo message to specified Telegram chat. The photo will be sourced from the provided URL and sent to Telegram. Several options can be specified to adjust message parameters.
.EXAMPLE
    $botToken = "nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-nnnnnnnnn"
    $photoURL = "https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/techthoughts.png"
    Send-TelegramURLPhoto -BotToken $botToken -ChatID $chat -PhotoURL $photourl

    Sends photo message via Telegram API
.EXAMPLE
    $botToken = "nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-nnnnnnnnn"
    $photoURL = "https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/techthoughts.png"
    Send-TelegramURLPhoto `
        -BotToken $botToken `
        -ChatID $chat `
        -PhotoURL $photourl `
        -Caption "DSC is a great technology" `
        -ParseMode Markdown `
        -DisableNotification `
        -Verbose

    Sends photo message via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER PhotoURL
    URL path to photo
.PARAMETER Caption
    Brief title or explanation for media
.PARAMETER ParseMode
    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message. Default is Markdown.
.PARAMETER DisableNotification
    Send the message silently. Users will receive a notification with no sound.
.OUTPUTS
    System.Management.Automation.PSCustomObject (if successful)
    System.Boolean (on failure)
.NOTES
    Author: Jake Morrison - @jakemorrison - https://techthoughts.info/
    This works with PowerShell Versions: 5.1, 6.0, 6.1

    For a description of the Bot API, see this page: https://core.telegram.org/bots/api
    How do I get my channel ID? Use the getidsbot https://telegram.me/getidsbot  -or-  Use the Telegram web client and copy the channel ID in the address
    How do I set up a bot and get a token? Use the BotFather https://t.me/BotFather
.COMPONENT
    PoshGram - https://github.com/techthoughts2/PoshGram
.FUNCTIONALITY
    Parameters              Type                    Required    Description
    chat_id                 Integer or String       Yes         Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    photo                   InputFile or string     Yes         Photo to send. Pass a file_id as String to send a photo that exists on the Telegram servers (recommended),
        pass an HTTP URL as a String for Telegram to get a photo from the Internet, or upload a new photo using multipart/form-data. More info on Sending Files
    caption                 String                  Optional    Photo caption (may also be used when resending photos by file_id), 0-200 characters
    parse_mode              String                  Optional    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in the media caption.
    disable_notification    Boolean                 Optional    Sends the message silently. Users will receive a notification with no sound.
.LINK
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramURLPhoto.md
.LINK
    https://core.telegram.org/bots/api#sendphoto
#>
function Send-TelegramURLPhoto {
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
            HelpMessage = 'URL path to photo')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$PhotoURL,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Photo caption')]
        [string]$Caption,
        [Parameter(Mandatory = $false,
            HelpMessage = 'HTML vs Markdown for message formatting')]
        [ValidateSet("Markdown", "HTML")]
        [string]$ParseMode = "Markdown", #set to Markdown by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'Send the message silently')]
        [switch]$DisableNotification
    )
    #------------------------------------------------------------------------
    $results = $true #assume the best
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying URL leads to supported photo extension..."
    $fileTypeEval = Test-URLExtension -URL $PhotoURL -Type Photo
    if ($fileTypeEval -eq $false) {
        $results = $false
        return $results
    }#if_photoExtension
    else {
        Write-Verbose -Message "Extension supported."
    }#else_photoExtension
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying URL presence and file size..."
    $fileSizeEval = Test-URLFileSize -URL $PhotoURL
    if ($fileSizeEval -eq $false) {
        $results = $false
        return $results
    }#if_photoSize
    else {
        Write-Verbose -Message "File size verified."
    }#else_photoSize
    #------------------------------------------------------------------------
    $payload = @{
        chat_id              = $ChatID
        photo                = $PhotoURL
        caption              = $Caption
        parse_mode           = $ParseMode
        disable_notification = $DisableNotification.IsPresent
    }#payload
    #------------------------------------------------------------------------
    $invokeRestMethodSplat = @{
        Uri         = ("https://api.telegram.org/bot{0}/sendphoto" -f $BotToken)
        Body        = (ConvertTo-Json -Compress -InputObject $payload)
        ErrorAction = 'Stop'
        ContentType = "application/json"
        Method      = 'Post'
    }
    #------------------------------------------------------------------------
    try {
        Write-Verbose -Message "Sending message..."
        $results = Invoke-RestMethod @invokeRestMethodSplat
    }#try_messageSend
    catch {
        Write-Warning "An error was encountered sending the Telegram message:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramURLPhoto