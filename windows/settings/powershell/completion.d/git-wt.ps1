# src: Documentation/powershell/completion.d/git-wt.ps1
# @(#) : worktrunk (git-wt) completion for powershell
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

if (Get-Command git-wt -ErrorAction SilentlyContinue) {
    $gitWtCompleter = {
        param($wordToComplete, $commandAst, $cursorPosition)

        $prev = $env:COMPLETE
        $env:COMPLETE = "powershell"

        $cmdLine = $commandAst.Extent.Text
        $cmdLine = $cmdLine.Substring(0, [math]::Min($cursorPosition, $cmdLine.Length))
        if ($wordToComplete -eq "") { $cmdLine += " ''" }

        $wtBin = (Get-Command git-wt -CommandType Application | Select-Object -First 1).Source
        $results = & $wtBin -- ($cmdLine -split ' ') 2>$null

        if ($null -eq $prev) {
            Remove-Item Env:\COMPLETE -ErrorAction SilentlyContinue
        } else {
            $env:COMPLETE = $prev
        }

        $results | ForEach-Object {
            $split = $_.Split("`t")
            $cmd = $split[0]
            $help = if ($split.Length -eq 2) { $split[1] } else { $split[0] }
            [System.Management.Automation.CompletionResult]::new($cmd, $cmd, 'ParameterValue', $help)
        }
    }

    Register-ArgumentCompleter -Native -CommandName 'git-wt', 'git-wt.exe' -ScriptBlock $gitWtCompleter
}
