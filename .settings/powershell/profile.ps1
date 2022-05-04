<#
  .SYNOPSIS
    PowerShell initialize script for CLI

  .NOTE
    Author:   Atsushi Furukawa <atsushifx@aglabo.com>
    License:  MIT License  https://opensource.org/licenses/MIT

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

#>
Set-StrictMode -version latest

# for import library
$Script = $MyInvocation.MyCommand.path
$myLibsDir = $PSScriptRoot + '/libs'
. ($myLibsDir + '/commonUtils.ps1')

### prompt
## set prompt

# Invoke-Expression (&starship init powershell)
<#
  .SYNOPSIS
    set default prompt for powershell

#>
function  prompt()
{
  param()

  $isAdmin = [myUserRole]::isAdmin()
  $prompt = $isAdmin ? " # " :  " > "
  $currentPath = (Split-Path (Get-Location) -Leaf)
  $currentDrive =(Convert-Path \).substring(0, 1)
  $userName =$env:USERNAME

  # Prompt return
  return $currentDrive+": /" + $currentPath + $prompt
}

## key binding
Set-PSReadLineOption -EditMode windows

# windows defaukt
Set-PSReadLineKeyHandler -chord Ctrl+A -function SelectAll
Set-PSReadLineKeyHandler -chord Ctrl+X -function cut

# Wz/Vz like +alpha
Set-PSReadLineKeyHandler -chord Ctrl+a -function ShellBackwardWord
Set-PSReadLineKeyHandler -chord Ctrl+s -function BackwardChar
Set-PSReadLineKeyHandler -chord Ctrl+d -function ForwardChar
Set-PSReadLineKeyHandler -chord Ctrl+f -function ShellForwardWord

Set-PSReadLineKeyHandler -chord Ctrl+g -function DeleteChar
Set-PSReadLineKeyHandler -chord Ctrl+t -function DeleteWord
Set-PSReadLineKeyHandler -chord Ctrl+u -function DeleteLine
Set-PSReadLineKeyHandler -chord Ctrl+y -function Paste
Set-PSReadLineKeyHandler -chord Ctrl+j -function Paste

# history
Set-PSReadLineKeyHandler -chord Ctrl+p -function PreviousHistory
Set-PSReadLineKeyHandler -chord Ctrl+n -function NextHistory



## Tab completion
Import-Module posh-git
Import-Module scoop-completion
#  volta completions
& volta completions powershell | Out-String | Invoke-Expression
