#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PoshGram'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$WarningPreference = "SilentlyContinue"
#-------------------------------------------------------------------------
#Import-Module $moduleNamePath -Force

InModuleScope PoshGram {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    $token = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-#########"
    #-------------------------------------------------------------------------
    Describe 'Send-TelegramURLPhoto' -Tag Unit {
        $videoURL = "https://github.com/techthoughts2/PoshGram/raw/master/test/SourceFiles/Intro.mp4"
        BeforeEach {
            mock Test-URLExtension { $true }
            mock Test-URLFileSize { $true }
            mock Invoke-RestMethod -MockWith {
                [PSCustomObject]@{
                    ok     = "True"
                    result = @{
                        message_id       = 2222
                        from             = "@{id=#########; is_bot=True; first_name=botname; username=bot_name}"
                        chat             = "@{id=-#########; title=ChatName; type=group; all_members_are_administrators=True}"
                        date             = "1530157540"
                        video            = "@{duration=17; width=1920; height=1080; mime_type=video/mp4; thumb=; file_id=BAADAQADPwADiOTBRROL3QmsMu9OAg;file_size=968478}"
                        caption          = "Video URL test"
                        caption_entities = "{@{offset=13; length=6; type=bold}}"
                    }
                }
            }#endMock
        }#before_each
        Context 'Error' {
            It 'should return false if the video extension is not supported' {
                mock Test-URLExtension { $false }
                Send-TelegramURLVideo `
                    -BotToken $token `
                    -ChatID $chat `
                    -VideoURL $videourl `
                    -Duration 16 `
                    -Width 1920 `
                    -Height 1080 `
                    -ParseMode Markdown `
                    -Streaming $false `
                    -DisableNotification `
                    -ErrorAction SilentlyContinue | Should -Be $false
            }#it
            It 'should return false if the file is too large' {
                mock Test-URLFileSize { $false }
                Send-TelegramURLVideo `
                    -BotToken $token `
                    -ChatID $chat `
                    -VideoURL $videourl `
                    -Duration 16 `
                    -Width 1920 `
                    -Height 1080 `
                    -ParseMode Markdown `
                    -Streaming $false `
                    -DisableNotification `
                    -ErrorAction SilentlyContinue | Should -Be $false
            }#it
            It 'should return false if an error is encountered' {
                Mock Invoke-RestMethod {
                    Throw 'Bullshit Error'
                }#endMock
                Send-TelegramURLVideo `
                    -BotToken $token `
                    -ChatID $chat `
                    -VideoURL $videourl `
                    -Duration 16 `
                    -Width 1920 `
                    -Height 1080 `
                    -ParseMode Markdown `
                    -Streaming $false `
                    -DisableNotification `
                    -ErrorAction SilentlyContinue | Should -Be $false
            }#it
        }#context_error
        Context 'Success' {
            It 'should return a custom PSCustomObject if successful' {
                Send-TelegramURLVideo `
                    -BotToken $token `
                    -ChatID $chat `
                    -VideoURL $videourl `
                    -Duration 16 `
                    -Width 1920 `
                    -Height 1080 `
                    -ParseMode Markdown `
                    -Streaming $false `
                    -DisableNotification `
                    | Should -BeOfType System.Management.Automation.PSCustomObject
            }#it
        }#context_success
    }#describe_Send-TelegramURLPhoto
}#inModule