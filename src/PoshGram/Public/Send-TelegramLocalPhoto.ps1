<#
.Synopsis
    Sends Telegram photo message via Bot API from locally sourced photo image
.DESCRIPTION
    Uses Telegram Bot API to send photo message to specified Telegram chat. The photo will be sourced from the local device and uploaded to telegram. Several options can be specified to adjust message parameters.
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $photo = "C:\photos\aphoto.jpg"
    Send-TelegramLocalPhoto -BotToken $botToken -ChatID $chat -PhotoPath $photo

    Sends photo message via Telegram API
.EXAMPLE
    $botToken = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    $photo = "C:\photos\aphoto.jpg"
    Send-TelegramLocalPhoto `
        -BotToken $botToken `
        -ChatID $chat `
        -PhotoPath $photo `
        -Caption "Check out this photo" `
        -ParseMode Markdown `
        -DisableNotification $false `
        -Verbose

    Sends photo message via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER PhotoPath
    File path to local image
.PARAMETER Caption
    Brief title or explanation for media
.PARAMETER ParseMode
    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in your bot's message. Default is Markdown.
.PARAMETER DisableNotification
    Sends the message silently. Users will receive a notification with no sound. Default is $false
.OUTPUTS
    System.Management.Automation.PSCustomObject (if successful)
    System.Boolean (on failure)
.NOTES
    Author: Jake Morrison - @jakemorrison - http://techthoughts.info/
    This works with PowerShell Version: 6.1

    The following photo types are supported:
    JPG, JPEG, PNG, GIF, BMP, WEBP, SVG, TIFF

    For a description of the Bot API, see this page: https://core.telegram.org/bots/api
    How do I get my channel ID? Use the getidsbot https://telegram.me/getidsbot  -or-  Use the Telegram web client and copy the channel ID in the address
    How do I set up a bot and get a token? Use the BotFather https://t.me/BotFather
.COMPONENT
    PoshGram - https://github.com/techthoughts2/PoshGram
.FUNCTIONALITY
    Parameters              Type                    Required    Description
    chat_id                 Integer or String       Yes         Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    photo                   InputFile or String     Yes         Photo to send. Pass a file_id as String to send a photo that exists on the Telegram servers (recommended),
        pass an HTTP URL as a String for Telegram to get a photo from the Internet, or upload a new photo using multipart/form-data. More info on Sending Files
    caption                 String                  Optional    Photo caption (may also be used when resending photos by file_id), 0-200 characters
    parse_mode              String                  Optional    Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width text or inline URLs in the media caption.
    disable_notification    Boolean                 Optional    Sends the message silently. Users will receive a notification with no sound.
.LINK
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramLocalPhoto.md
.LINK
    https://core.telegram.org/bots/api#sendphoto
#>
function Send-TelegramLocalPhoto {
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
            HelpMessage = 'File path to the photo you wish to send')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$PhotoPath,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Photo caption')]
        [string]$Caption = "", #set to false by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'HTML vs Markdown for message formatting')]
        [ValidateSet("Markdown", "HTML")]
        [string]$ParseMode = "Markdown", #set to Markdown by default
        [Parameter(Mandatory = $false,
            HelpMessage = 'Sends the message silently')]
        [bool]$DisableNotification = $false #set to false by default
    )
    #------------------------------------------------------------------------
    $results = $true #assume the best
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying presence of photo..."
    if (!(Test-Path -Path $PhotoPath)) {
        Write-Warning "The specified photo path: $PhotoPath was not found."
        $results = $false
        return $results
    }#if_testPath
    else{
        Write-Verbose -Message "Path verified."
    }#else_testPath
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying extension type..."
    $fileTypeEval = Test-FileExtension -FilePath $PhotoPath -Type Photo
    if ($fileTypeEval -eq $false) {
        $results = $false
        return $results
    }#if_photoExtension
    else {
        Write-Verbose -Message "Extension supported."
    }#else_photoExtension
    #------------------------------------------------------------------------
    Write-Verbose -Message "Verifying file size..."
    $fileSizeEval = Test-FileSize -Path $PhotoPath
    if ($fileSizeEval -eq $false) {
        $results = $false
        return $results
    }#if_photoSize
    else {
        Write-Verbose -Message "File size verified."
    }#else_photoSize
    #------------------------------------------------------------------------
    try {
        $fileObject = Get-Item $PhotoPath -ErrorAction Stop
    }#try_Get-ItemPhoto
    catch {
        Write-Warning "The specified photo could not be interpreted properly."
        $results = $false
        return $results
    }#catch_Get-ItemPhoto
    #------------------------------------------------------------------------
    $uri = "https://api.telegram.org/bot$BotToken/sendphoto"
    $Form = @{
        chat_id              = $ChatID
        photo                = $fileObject
        caption              = $Caption
        parse_mode           = $ParseMode
        disable_notification = $DisableNotification
    }#form
    #------------------------------------------------------------------------
    try {
        $results = Invoke-RestMethod -Uri $Uri -Method Post -Form $Form -ErrorAction Stop
    }#try_messageSend
    catch {
        Write-Warning "An error was encountered sending the Telegram photo message:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramLocalPhoto