#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PoshGram'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope PoshGram {
    Describe 'Send-TelegramURLSticker' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            $token = '#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
            $chat = '-nnnnnnnnn'
            $StickerURL = 'https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/techthoughts.webp'
            Mock Test-URLExtension { $true }
            Mock Test-URLFileSize { $true }
            Mock Invoke-RestMethod -MockWith {
                [PSCustomObject]@{
                    ok     = 'True'
                    result = @{
                        message_id = '1635'
                        from       = '@{id=515383114; is_bot=True; first_name=poshgram; username=poshgram_bot}'
                        chat       = '@{id=-192990862; title=PoshGram Testing; type=group; all_members_are_administrators=True}'
                        date       = '1571382575'
                        sticker    = '@{width=512; height=512; is_animated=False; thumb=; file_id=CAADBAADkAEAAvRXTVFFkzUj6CRvGRYE; file_size=18356}'
                    }
                }
            } #endMock
        } #before_each
        Context 'Error' {
            It 'should return false if the sticker extension is not supported' {
                Mock Test-URLExtension { $false }
                $sendTelegramURLStickerSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    StickerURL          = $StickerURL
                    DisableNotification = $true
                    ErrorAction         = 'SilentlyContinue'
                }
                Send-TelegramURLSticker @sendTelegramURLStickerSplat | Should -Be $false
            } #it

            It 'should return false if the file is too large' {
                Mock Test-URLFileSize { $false }
                $sendTelegramURLStickerSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    StickerURL          = $StickerURL
                    DisableNotification = $true
                    ErrorAction         = 'SilentlyContinue'
                }
                Send-TelegramURLSticker @sendTelegramURLStickerSplat | Should -Be $false
            } #it

            It 'should return false if an error is encountered' {
                Mock Invoke-RestMethod {
                    throw 'Bullshit Error'
                } #endMock
                $sendTelegramURLStickerSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    StickerURL          = $StickerURL
                    DisableNotification = $true
                    ErrorAction         = 'SilentlyContinue'
                }
                Send-TelegramURLSticker @sendTelegramURLStickerSplat | Should -Be $false
            } #it
        } #context_error
        Context 'Success' {
            It 'should return a custom PSCustomObject if successful' {
                $sendTelegramURLStickerSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    StickerURL          = $StickerURL
                    DisableNotification = $true
                }
                Send-TelegramURLSticker @sendTelegramURLStickerSplat | Should -BeOfType System.Management.Automation.PSCustomObject
            } #it
        } #context_success
    } #describe_Send-TelegramURLSticker
} #inModule
