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
    Describe 'Send-TelegramLocalPhoto' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        BeforeEach {
            $token = '#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
            $chat = '-nnnnnnnnn'
            Mock Test-Path { $true }
            Mock Test-FileExtension { $true }
            Mock Test-FileSize { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    Mode          = 'True'
                    LastWriteTime = '06/17/16     00:19'
                    Length        = '1902'
                    Name          = 'diagvresults.jpg'
                }
            } #endMock
            Mock Invoke-RestMethod -MockWith {
                [PSCustomObject]@{
                    ok     = 'True'
                    result = @{
                        message_id       = 2222
                        from             = '@{id=#########; is_bot=True; first_name=botname; username=bot_name}'
                        chat             = '@{id=-#########; title=ChatName; type=group; all_members_are_administrators=True}'
                        date             = '1530157540'
                        photo            = '{@{file_id=AgADAQAD-qcxG3V1oUWan8rsJbPxtH6vCjAABG9Ju7DQr02GYgMBAAEC; file_size=1084;file_path=photos/file_427.jpg; width=90; height=85},@{file_id=AgADAQAD-qcxG3V1oUWan8rsJbPxtH6vCj################; file_size=2305; width=123;height=116}}'
                        caption          = 'Please work, please'
                        caption_entities = '{@{offset=13; length=6; type=bold}}'
                    }
                }
            } #endMock
        } #before_each
        Context 'Error' {
            It 'should throw if the photo can not be found' {
                Mock Test-Path { $false }
                $sendTelegramLocalPhotoSplat = @{
                    BotToken  = $token
                    ChatID    = $chat
                    PhotoPath = 'c:\bs\diagvresults.jpg'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat } | Should -Throw
            } #it

            It 'should throw if the photo extension is not supported' {
                Mock Test-FileExtension { $false }
                $sendTelegramLocalPhotoSplat = @{
                    BotToken  = $token
                    ChatID    = $chat
                    PhotoPath = 'c:\bs\diagvresults.jpg'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat } | Should -Throw
            } #it

            It 'should throw if the photo is too large' {
                Mock Test-FileSize { $false }
                $sendTelegramLocalPhotoSplat = @{
                    BotToken  = $token
                    ChatID    = $chat
                    PhotoPath = 'c:\bs\diagvresults.jpg'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat } | Should -Throw
            } #it

            It 'should throw if it cannot successfully get the file' {
                Mock Get-Item {
                    throw 'Fake Error'
                } #endMock
                $sendTelegramLocalPhotoSplat = @{
                    BotToken  = $token
                    ChatID    = $chat
                    PhotoPath = 'c:\bs\diagvresults.jpg'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat } | Should -Throw
            } #it

            It 'should throw if an error is encountered with no specific exception' {
                Mock Invoke-RestMethod {
                    throw 'Fake Error'
                } #endMock
                $sendTelegramLocalPhotoSplat = @{
                    BotToken    = $token
                    ChatID      = $chat
                    PhotoPath   = 'c:\bs\diagvresults.jpg'
                    ErrorAction = 'SilentlyContinue'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat } | Should -Throw
            } #it

            It 'should run the expected commands if an error is encountered' {
                Mock -CommandName Invoke-RestMethod {
                    throw 'Fake Error'
                } #endMock
                Mock -CommandName Write-Warning { }
                $sendTelegramLocalPhotoSplat = @{
                    BotToken    = $token
                    ChatID      = $chat
                    PhotoPath   = 'c:\bs\diagvresults.jpg'
                    ErrorAction = 'SilentlyContinue'
                }
                { Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat
                    Should -Invoke -CommandName Write-Warning -Times 1 -Scope It }
            } #it

            It 'should return the exception if the API returns an error' {
                Mock -CommandName Invoke-RestMethod {
                    $errorDetails = '{ "ok":false, "error_code":429, "description":"Too Many Requests: retry after 10", "parameters": { "retry_after":10 } }'
                    $statusCode = 429
                    $response = New-Object System.Net.Http.HttpResponseMessage $statusCode
                    $exception = New-Object Microsoft.PowerShell.Commands.HttpResponseException "$statusCode ($($response.ReasonPhrase))", $response

                    $errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation

                    $errorID = 'WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand'
                    $targetObject = $null
                    $errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
                    $errorRecord.ErrorDetails = $errorDetails
                    throw $errorRecord
                } #endMock
                $sendTelegramLocalPhotoSplat = @{
                    BotToken    = $token
                    ChatID      = $chat
                    PhotoPath   = 'c:\bs\diagvresults.jpg'
                    ErrorAction = 'SilentlyContinue'
                }
                $eval = Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat
                $eval.ok | Should -BeExactly 'False'
                $eval.error_code | Should -BeExactly '429'
            } #it
        } #context_Error
        Context 'Success' {
            It 'should call the API with the expected parameters' {
                Mock -CommandName Invoke-RestMethod {
                } -Verifiable -ParameterFilter { $Uri -like 'https://api.telegram.org/bot*sendphoto*' }
                $sendTelegramLocalPhotoSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    PhotoPath           = 'c:\bs\diagvresults.jpg'
                    Caption             = 'Check out this photo'
                    ParseMode           = 'MarkdownV2'
                    DisableNotification = $true
                    ProtectContent      = $true
                }
                Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat
                Assert-VerifiableMock
            } #it

            It 'should return a custom PSCustomObject if successful' {
                $sendTelegramLocalPhotoSplat = @{
                    BotToken            = $token
                    ChatID              = $chat
                    PhotoPath           = 'c:\bs\diagvresults.jpg'
                    Caption             = 'Check out this photo'
                    ParseMode           = 'MarkdownV2'
                    DisableNotification = $true
                    ProtectContent      = $true
                }
                $eval = Send-TelegramLocalPhoto @sendTelegramLocalPhotoSplat
                $eval | Should -BeOfType System.Management.Automation.PSCustomObject
                $eval.ok | Should -BeExactly 'True'
            } #it
        } #context_Success
    } #describe_Send-TelegramLocalPhoto
} #inModule
