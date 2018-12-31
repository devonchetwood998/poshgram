<#
.Synopsis
    Sends Telegram video message via Bot API from URL sourced file
.DESCRIPTION
    Uses Telegram Bot API to send video message to specified Telegram chat. The file will be sourced from the provided URL and sent to Telegram. Several options can be specified to adjust message parameters. Only works for gif, pdf and zip files.
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $videourl = "https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/Intro.mp4"
    Send-TelegramURLVideo -BotToken $botToken -ChatID $chat -VideoURL $videourl

    Sends video message via Telegram API
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $videourl = "https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/Intro.mp4"
    Send-TelegramURLVideo `
        -BotToken $botToken `
        -ChatID $chat `
        -VideoURL $videourl `
        -Duration 16 `
        -Width 1920 `
        -Height 1080 `
        -Caption "Check out this video" `
        -ParseMode Markdown `
        -Streaming $false `
        -DisableNotification $false `
        -Verbose

    Sends video message via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER VideoURL
    URL path to video file
.PARAMETER Duration
    Duration of sent video in seconds
.PARAMETER Width
    Video width
.PARAMETER Height
    Video height
.PARAMETER Caption
    Brief title or explanation for media
.PARAMETER ParseMode
    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message. Default is Markdown.
.PARAMETER Streaming
    Pass True, if the uploaded video is suitable for streaming
.PARAMETER DisableNotification
    Sends the message silently. Users will receive a notification with no sound. Default is $false
.OUTPUTS
    System.Management.Automation.PSCustomObject (if successful)
    System.Boolean (on failure)
.NOTES
    Author: Jake Morrison - @jakemorrison - http://techthoughts.info/
    This works with PowerShell Versions: 5.1, 6.0, 6.1

    Telegram clients support mp4 videos (other formats may be sent as Document)
    Bots can currently send video files of up to 50 MB in size, this limit may be changed in the future.

    For a description of the Bot API, see this page: https://core.telegram.org/bots/api
    How do I get my channel ID? Use the getidsbot https://telegram.me/getidsbot  -or-  Use the Telegram web client and copy the channel ID in the address
    How do I set up a bot and get a token? Use the BotFather https://t.me/BotFather
.COMPONENT
    PoshGram - https://github.com/techthoughts2/PoshGram
.FUNCTIONALITY
    Parameters 				Type    				Required 	Description
    chat_id 				Integer or String 		Yes 		Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    video    				InputFile or String 	Yes 		Video to send. Pass a file_id as String to send a video that exists on the Telegram servers (recommended), pass an HTTP URL as a String for Telegram to get a video from the Internet, or upload a new video using multipart/form-data.
    duration                Integer                 Optional    Duration of sent video in seconds
    width                   Integer                 Optional    Video width
    height                  Integer                 Optional    Video height
    caption 				String 					Optional 	Photo caption (may also be used when resending photos by file_id), 0-200 characters
    parse_mode 				String 					Optional 	Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in the media caption.
    supports_streaming      Boolean                 Optional    Pass True, if the uploaded video is suitable for streaming
    disable_notification 	Boolean 				Optional 	Sends the message silently. Users will receive a notification with no sound.
.LINK
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramURLVideo.md
.LINK
    https://core.telegram.org/bots/api#sendvideo
#>
function Send-TelegramURLVideo {
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
            HelpMessage = 'URL to file you wish to send')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VideoURL,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Duration of video in seconds')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Int32]$Duration,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Video width')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Int32]$Width,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Video height')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Int32]$Height,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Caption for file')]
        [string]$Caption = "", #set to false by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'HTML vs Markdown for message formatting')]
        [ValidateSet("Markdown", "HTML")]
        [string]$ParseMode = "Markdown", #set to Markdown by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'Pass True, if the uploaded video is suitable for streaming')]
        [bool]$Streaming, #set to Markdown by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'Sends the message silently')]
        [bool]$DisableNotification = $false #set to false by default
    )
    #------------------------------------------------------------------------
    $results = $true #assume the best
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying URL leads to supported document extension..."
    $fileTypeEval = Test-VideoURLExtension -URL $VideoURL
    if ($fileTypeEval -eq $false) {
        $results = $false
        return $results
    }#if_documentExtension
    else {
        Write-Verbose -Message "Extension supported."
    }#else_documentExtension
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying URL presence and file size..."
    $fileSizeEval = Test-URLFileSize -URL $VideoURL
    if ($fileSizeEval -eq $false) {
        $results = $false
        return $results
    }#if_documentSize
    else {
        Write-Verbose -Message "File size verified."
    }#else_documentSize
    #------------------------------------------------------------------------
    $payload = @{
        chat_id              = $ChatID
        video                = $VideoURL
        duration             = $Duration
        width                = $Width
        height               = $Height
        caption              = $Caption
        parse_mode           = $ParseMode
        supports_streaming   = $Streaming
        disable_notification = $DisableNotification
    }#payload
    #------------------------------------------------------------------------
    try {
        Write-Verbose -Message "Sending message..."
        $results = Invoke-RestMethod `
            -Uri ("https://api.telegram.org/bot{0}/sendVideo" -f $BotToken) `
            -Method Post `
            -ContentType "application/json" `
            -Body (ConvertTo-Json -Compress -InputObject $payload) `
            -ErrorAction Stop
    }#try_messageSend
    catch {
        Write-Warning "An error was encountered sending the Telegram message:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramURLVideo