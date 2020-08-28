﻿<#
.Synopsis
    Sends Telegram animated emoji that will display a random value.
.DESCRIPTION
    Uses Telegram Bot API to send animated emoji that will display a random value to specified Telegram chat.
.EXAMPLE
    $botToken = "nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-nnnnnnnnn"
    $emoji = 'basketball'
    Send-TelegramDice -BotToken $botToken -ChatID $chat -Emoji $emoji

    Sends animated basketball emoji that displays a random value via Telegram API
.EXAMPLE
    $botToken = "nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-nnnnnnnnn"
    $emoji = 'dice'
    $sendTelegramDiceSplat = @{
        BotToken            = $botToken
        ChatID              = $chat
        DisableNotification = $true
        Verbose             = $true
        Emoji               = $emoji
    }
    Send-TelegramDice @sendTelegramDiceSplat

    Sends animated dice emoji that displays a random value via Telegram API
.PARAMETER BotToken
    Use this token to access the HTTP API
.PARAMETER ChatID
    Unique identifier for the target chat
.PARAMETER Emoji
    Emoji on which the dice throw animation is based.
.PARAMETER DisableNotification
    Send the message silently. Users will receive a notification with no sound.
.OUTPUTS
    System.Management.Automation.PSCustomObject (if successful)
    System.Boolean (on failure)
.NOTES
    Author: Jake Morrison - @jakemorrison - https://techthoughts.info/
    This works with PowerShell Version: 6.1+

    For a description of the Bot API, see this page: https://core.telegram.org/bots/api
    How do I get my channel ID? Use the getidsbot https://telegram.me/getidsbot  -or-  Use the Telegram web client and copy the channel ID in the address
    How do I set up a bot and get a token? Use the BotFather https://t.me/BotFather
.COMPONENT
    PoshGram - https://github.com/techthoughts2/PoshGram
.FUNCTIONALITY
    Parameters              Type                    Required    Description
    chat_id                 Integer or String       Yes         Unique identifier for the target chat or username of the target channel (in the format @channelusername)
    latitude                Float number            Yes         Latitude of the location
    longitude               Float number            Yes         Longitude of the location
    disable_notification    Boolean                 Optional    Sends the message silently. Users will receive a notification with no sound.
.LINK
    https://github.com/techthoughts2/PoshGram/blob/master/docs/Send-TelegramDice.md
.LINK
    https://core.telegram.org/bots/api#senddice
#>
function Send-TelegramDice {
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
            HelpMessage = 'Emoji on which the dice throw animation is based.')]
        [ValidateSet('dice', 'dart', 'basketball')]
        [string]$Emoji,
        [Parameter(Mandatory = $false,
            HelpMessage = 'Send the message silently')]
        [switch]$DisableNotification
    )
    #------------------------------------------------------------------------
    $results = $true #assume the best
    #------------------------------------------------------------------------
    switch ($Emoji) {
        dice {
            $emojiSend = '🎲'
        }
        dart {
            $emojiSend = '🎯'
        }
        basketball {
            $emojiSend = '🏀'
        }
    }
    #------------------------------------------------------------------------
    $uri = "https://api.telegram.org/bot$BotToken/sendDice"
    $Form = @{
        chat_id              = $ChatID
        emoji                = $emojiSend
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
        Write-Warning "An error was encountered sending the Telegram location:"
        Write-Error $_
        $results = $false
    }#catch_messageSend
    return $results
    #------------------------------------------------------------------------
}#function_Send-TelegramDice