<#
.Synopsis
    Sends Telegram video message via Bot API from locally sourced file
.DESCRIPTION
    Uses Telegram Bot API to send video message to specified Telegram chat. The video will be sourced from the local device and uploaded to telegram. Several options can be specified to adjust message parameters. Telegram only supports mp4 videos.
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $file = "C:\videos\video.mp4"
    Send-TelegramLocalVideo -BotToken $botToken -ChatID $chat -Video $video

    Sends video message via Telegram API
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $video = "C:\videos\video.mp4"
    Send-TelegramLocalVideo `
        -BotToken $botToken `
        -ChatID $chat `
        -Video $video `
        -Duration 10 `
        -Width 250 `
        -Height 250 `
        -Caption "Check out this video" `
        -ParseMode Markdown `
        -Streaming $true `
        -DisableNotification $false `
        -Verbose

    Sends video message via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER Video
    Local path to video file
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
    Contributor: Mark Kraus - @markekraus - thanks for the form tip!
    This works with PowerShell Version: 6.1

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
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramLocalVideo.md
.LINK
    https://core.telegram.org/bots/api#sendvideo
#>
function Send-TelegramLocalVideo {
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
        [string]$Video,
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
    Write-Verbose -Message "Verifying presence of file..."
    if (!(Test-Path -Path $Video)) {
        Write-Warning "The specified file: $Video was not found."
        $results = $false
        return $results
    }#if_testPath
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying extension type..."
    $fileTypeEval = Test-FileExtension -FilePath $Video -Type Video
    if ($fileTypeEval -eq $false) {
        $results = $false
        return $results
    }#if_videoExtension
    else {
        Write-Verbose -Message "Extension supported."
    }#else_videoExtension
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying file size..."
    $fileSizeEval = Test-FileSize -Path $Video
    if ($fileSizeEval -eq $false) {
        $results = $false
        return $results
    }#if_videoSize
    else {
        Write-Verbose -Message "File size verified."
    }#else_videoSize
    #------------------------------------------------------------------------
    try {
        $fileObject = Get-Item $Video -ErrorAction Stop
    }#try_Get-ItemVideo
    catch {
        Write-Warning "The specified file could not be interpreted properly."
        $results = $false
        return $results
    }#catch_Get-ItemVideo
    #------------------------------------------------------------------------
    $uri = "https://api.telegram.org/bot$BotToken/sendVideo"
    $Form = @{
        chat_id              = $ChatID
        video                = $fileObject
        duration             = $Duration
        width                = $Width
        height               = $Height
        caption              = $Caption
        parse_mode           = $ParseMode
        supports_streaming   = $Streaming
        disable_notification = $DisableNotification
    }#form
    #------------------------------------------------------------------------
    try {
        $results = Invoke-RestMethod -Uri $Uri -Method Post -Form $Form -ErrorAction Stop
    }#try_messageSend
    catch {
        Write-Warning "An error was encountered sending the Telegram video message:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramLocalVideo