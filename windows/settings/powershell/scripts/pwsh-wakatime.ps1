# Import-Module posh-git

## PROMPT MANAGEMENT ###########################################################

<#
    .SYNOPSIS
        Modifies the current prompt to send wakatime a tick.
    .EXAMPLE
        Send-HeartbeatAtPrompt

        Causes a WakaTime heartbeat sent at the current session's prompt.
#>

function Test-Wakatime {return $(if($(where.exe wakatime)) {$True} else {$False})}

function Send-WakaTimeHeartbeat(){
    if (!$(where.exe wakatime)) {return;}
    $command = "";
    try {
        $historyItem = (Get-History | Select-Object -Last 1)
        $commandObj = ($historyItem | Select-Object -Property CommandLine).CommandLine
        $commandText = ([regex]::split($commandObj,"[ |;:]")[0])
        $command = $commandText.Replace("(","")
    } catch [Exception] {
        if($command -eq "") {
            $command = "error"
        }
    }
    $gitFolder = (Get-GitDirectory);
    Get-Job -State Completed|Where-Object{$_.Name.Contains("WakaJob")}|Remove-Job
    $job = Start-Job -Name "WakaJob" -ScriptBlock {
        param($command, $gitFolder)

        Write-Host "Sending wakatime"
        Write-Host "Waka command: $command"
        if($command -eq "") {return;}

        $PLUGIN_VERSION = "0.1.1";

        $wakaCommand = 'wakatime --write'
        $wakaCommand+= " --plugin `"powershell-wakatime-plugin/$PLUGIN_VERSION`""
        $wakaCommand+= ' --entity-type app '
        $wakaCommand+= ' --entity "'
        $wakaCommand+=  $command
        $wakaCommand+= '" '
        $wakaCommand+= ' --language "PowerShell" '

        if($null -eq $gitFolder){
            $wakaCommand =$wakaCommand + ' --project '
            $wakaCommand =$wakaCommand + 'Terminal'
        } else {
            $gitFolder = (Get-Item ($gitFolder).Replace(".git",""))
            $wakaCommand =$wakaCommand + ' --project "'
            $wakaCommand =$wakaCommand + $gitFolder.Name
            $wakaCommand =$wakaCommand + '" '
        }
        $wakaCommand
        Invoke-Expression $wakaCommand
    } -ArgumentList $command, $gitFolder
}

function Send-HeartbeatAtPrompt() {
    function global:prompt() {
        Send-WakaTimeHeartbeat
        WakaTimePromptBackup;
    }
}

# Use the same procedure as in conda to nest prompts.
# Guard against re-loading: skip setup if already initialized.
if (-not (Test-Path Function:\WakaTimePromptBackup)) {
    if (Test-Path Function:\prompt) {
        Rename-Item Function:\prompt WakaTimePromptBackup
    } else {
        function WakaTimePromptBackup() {
            # Restore a basic prompt if the definition is missing.
            "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
        }
    }
    Send-HeartbeatAtPrompt
}
