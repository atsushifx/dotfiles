# src: Documentation/powershell/completion.d/git-wt.ps1
# @(#) : worktrunk (git-wt) completion for powershell
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# cspell:words worktrunk

# git wt completion for powershell
if (Get-Command git-wt -ErrorAction SilentlyContinue) {
    $gitWtBin = (Get-Command git-wt -CommandType Application | Select-Object -First 1).Source

    . {
        # Invoke git-wt binary with COMPLETE=fish (tab-delimited output with descriptions)
        $invokeCompletion = {
            param(
                [string]$BinPath,
                [string[]]$Arguments
            )
            $prev = $env:COMPLETE
            $env:COMPLETE = "powershell"
            try {
                & $BinPath -- @Arguments
            }
            finally {
                if ($null -eq $prev) {
                    Remove-Item Env:\COMPLETE -ErrorAction SilentlyContinue
                } else {
                    $env:COMPLETE = $prev
                }
            }
        }

        # Convert tab-delimited completion output lines into CompletionResult objects
        $convertResult = {
            param(
                [string]$Line
            )
            $split = $Line.Split("`t")
            $cmd   = $split[0]
            $help  = if ($split.Length -ge 2) { $split[1] } else { $cmd }
            [System.Management.Automation.CompletionResult]::new($cmd, $cmd, 'ParameterValue', $help)
        }

        $gitWtCompleter = {
            param($wordToComplete, $commandAst, $cursorPosition)

            $tokens = @($commandAst.CommandElements | ForEach-Object { $_.Extent.Text })
            if ($wordToComplete -eq "") { $tokens += "" }

            & $invokeCompletion $gitWtBin $tokens |
                ForEach-Object { & $convertResult $_ }
        }.GetNewClosure()

        # git wt としての補完（git サブコマンドとして呼び出した場合）
        $gitWtAsSubcommandCompleter = {
            param($wordToComplete, $commandAst, $cursorPosition)

            # posh-git と同じ方式で textToComplete を構築（末尾スペース保持のためパディングが必要）
            $padLength = $cursorPosition - $commandAst.Extent.StartOffset
            $textToComplete = $commandAst.ToString().PadRight($padLength, ' ').Substring(0, $padLength)

            # git wt ... の場合のみ処理、それ以外は posh-git にフォールバック
            if ($textToComplete -notmatch '^git\s+wt(\s|$)') {
                if (Get-Command Expand-GitCommand -ErrorAction SilentlyContinue) {
                    return Expand-GitCommand $textToComplete
                }
                return
            }

            # git wt → git-wt に変換してバイナリに委譲
            $allTokens = @($commandAst.CommandElements | ForEach-Object { $_.Extent.Text })
            $tokens = @("git-wt") + ($allTokens | Select-Object -Skip 2)
            if ($wordToComplete -eq "") { $tokens += "" }

            & $invokeCompletion $gitWtBin $tokens |
                ForEach-Object { & $convertResult $_ }
        }.GetNewClosure()

        Register-ArgumentCompleter -Native -CommandName 'git-wt', 'git-wt.exe' -ScriptBlock $gitWtCompleter
        Register-ArgumentCompleter -Native -CommandName 'git' -ScriptBlock $gitWtAsSubcommandCompleter
    }
}
