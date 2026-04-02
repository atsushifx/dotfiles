<#
.SYNOPSIS
command line editing functions library

.DESCRIPTION
command line function library for powershell.

.NOTES
@Author     Furukawa, Atsushi <atsushifx@aglabo.com>
@License    MIT License https://opensource.org/licenses/MIT

@date           2023-05-31
@Version    1.1.0

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>
Set-StrictMode -version latest

###
###     Functions
###

<#
.SYNOPSIS
    Retrieves the global command history from the PowerShell history file.

.DESCRIPTION
    The `Get-Global-History` function reads the command history from PSReadLine's history file,
    removes any empty lines and duplicate entries, and returns the cleaned global command history.
    You can optionally specify the number of entries to retrieve from the beginning or the end of the history.

.PARAMETER Head
    An integer specifying the number of entries to retrieve from the beginning of the history.

.PARAMETER Tail
    An integer specifying the number of entries to retrieve from the end of the history.

.EXAMPLE
  Get-Global-History -Tail 20

    Retrieves the last 20 commands from the global history.

.NOTES
    Requires:
    - PowerShell 5.0 or later
    - PSReadLine module

    Description:
        This function accesses the persistent command history file used by PSReadLine,
#>
function global:Get-Global-History() {
    param(
        [int]$Head,
        [int]$Tail
    )

    begin {
        $historyPath = (Get-PSReadLineOption).HistorySavePath
        $maxHistoryCount = 100
    }
    process {
        $globalHistory = (Get-Content -Path $historyPath)| tail -$maxHistoryCount | Where-Object { $_ -ne "" } | Select-Object -Unique
    }
    end {
        echo ($globalHistory.Count)
        $history = $globalHistory

        if ($Head -gt 0) {
            $history = $history | Select-Object -First $Head
        }
        if ($Tail -gt 0) {
            $history = $history | Select-Object -Last $Tail
        }
        $history
    }
}
Set-Alias -Name ggh -Value global:Get-Global-History -Description { "get global history from PSReadLine" }


<#
.SYNOPSIS
Executes a command with optional history management and command line editing.

.DESCRIPTION
The `Execute_Command` function execute commands as instead of Invoke-Expression
"-Send" switch is execute command as cli input.
"-Enter" switch is send enter after command input for execute command.

.PARAMETER command
execute command string

.PARAMETER send
sends the command to the command line editor instead of executing it immediately.

.PARAMETER Enter
use with "-Send", this switch send "Enter" to execute command.

.NOTES
This script provides a convenient way to execute commands with enhanced control over command history and editing.
#>
function global:Execute-Command() {
    param(
        [Parameter(Mandatory)][string]$command,
        [Switch]$Send,
        [Switch]$Enter
    )

    if ($send) {
        # execute command with readline function
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()

        if ($Enter) {
            [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
        }
    }
    else {
        Invoke-Expression($command)
    }
}

<#
.SYNOPSIS
    Selects a command from history using fzf and edit or executes it.

.DESCRIPTION
    The `Execute_History` function displays the command history from newest to oldest.
    It allows you to select a command using `fzf`. You can choose to execute the selected
    command immediately or insert it into the command line for editing before execution
    by using the `-Send` switch.

.PARAMETER Send
    true: select command is inserted in to command line to edit before execute it.

.NOTES
    Requires:
  - PowerShell 5.0 or later
    - `tac` (from BusyBox or CoreUtils)
    - `fzf` (fuzzy finder) installed and available in the system PATH

#>
function Execute-History() {
    param(
        [switch]$send
    )

    $command = (global:Get-Global-History -Tail 20) | tac | fzf --select-1
    if ($?) {
        Execute-Command $command -send:$send
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-Alias -Name hh -Value "Execute-History"

<#
.SYNOPSIS
    Get Process Object of Parent Process called by ProcessID

.DESCRIPTION
    The `Get-ParentProcessId` function find Parent Process ID (PPID) using WMI.

.PARAMETER ProcessId
    The Process ID (PID) of the child process

.EXAMPLE
    Get-ParentProcessId $PID

    the PPID from $PID (=powershell) is Windows Terminal's ID

.NOTES
    Requirements:
        - Appropriate permissions to perform WMI queries.
        - WMI must be enabled and accessible on the system.

    Caution:
        - Some security software may block WMI queries, which can prevent this function from working properly.

.LINK
    - [Get-Process](https://docs.microsoft.com/powershell/module/microsoft.powershell.management/get-process)
  - [Get-WmiObject](https://docs.microsoft.com/powershell/module/microsoft.powershell.management/get-wmiobject)

#>
function global:Get-ParentProcessId {
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int]$ProcessID
    )

    process {
        $query = "SELECT ParentProcessId FROM Win32_Process WHERE ProcessId = $ProcessId"
        $parentID = (Get-WmiObject -Query $query).ParentProcessId
        $parentID
    }
}
