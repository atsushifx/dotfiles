<#
  .SYNOPSIS
    PowerShell initialize script for CLI

  .DESCRIPTION
    powershell initialize script.
    this is:
      set Script Variables through `libs/commonSettings.inc.ps1'
      set prediction with completion
      customize key config
      setup completion from `completion.d/*/ps1'
      set wakatime heartbeat


  .NOTES
    @Author   Furukawa, Atsushi <atsushifx@aglabo.com>
    @License  MIT License https://opensource.org/licenses/MIT

    @Date     2023-05-31
    @Version  1.0.5

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

## Script Setup
Set-StrictMode -version latest
. $PSScriptRoot'/libs/commonSettings.inc.ps1'

### Libraries
. ($agLIBSDIR + "cliFunctions.inc.ps1")  # for readline function

$private:baseDir = Split-Path -path $profile
$env:PATH += ":" + $agSCRIPTSDIR

### functions
## prompt
# Invoke-Expression (&starship init powershell)
<#
  .SYNOPSIS
    set default prompt for powershell

#>
function global:prompt() {

	# define prompt
	$isAdmin = [aglaUserRole]::isAdmin()
	$psChar = $isAdmin ? " # " :  " > "
	$currentPath = (Split-Path (Get-Location) -Leaf)
	$currentDrive = (Convert-Path \).substring(0, 1)
	$userName = $env:USERNAME

	# Prompt return
	$prompt = $currentDrive + ": /" + $currentPath + $psChar
	$prompt
}

<#
  .SYNOPSIS
  write sudo message if user works as admin
#>
function private:write-sudo-messages() {
	$white = "$([char]0x1b)[37;1m"
	$cyan = "$([char]0x1b)[36;1m"
	$neutral = "$([char]0x1b)[m"
	$messages = "${white}You gave ...${neutral}`n
    ${cyan}#1${neutral}) Respect the privacy of others.
    ${cyan}#2${neutral}) Think before you type.
    ${cyan}#3${neutral}) With great power comes great responsibility.
  "
	$messages | write-output
}

<#
	.SYNOPSIS
	set current working directory to workspaces if call from menu/explorer
#>
function private:Set-WorkingDir() {
	$cur = Get-Location
	if ($cur -eq $env:USERPROFILE) {
		Set-Location $USERPROFILE+"/workspaces"
	}
}


### main routine
##
Set-WorkingDir

## input History Plugin
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{ InLinePrediction = [ConsoleColor]::Cyan }

## key binding
. ($agLIBSDIR + "keyConfig.inc.ps1" )

### Modules

## scoop
Invoke-Expression (&scoop-search-multisource -hook)

# carapace completion tool for powershell
$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# carapace _carapace | Out-String | Invoke-Expression # setup source in completion.d

## tab completion
Import-Module -Name CompletionPredictor
# Get-ChildItem -Path "$basedir/completion.d/*.ps1" | ForEach-Object { write-output $_.BaseName && . $_.FullName }
Get-ChildItem -Path "$basedir/completion.d/*.ps1" | ForEach-Object { . $_.FullName }

## Other tools
$env:NODE_PATH = $env:PNPM_HOME + "\5\node_modules"



# Wakatime setup
# use wakatime for windows
. "$agSCRIPTSDIR/pwsh-wakatime.ps1"


# BuildTools Path

# pnpm monorepo

# setup ocaml
# (& opam env) -split '\r?\n' | ForEach-Object { Invoke-Expression $_ }

## for sudo / admin

# sudo messages
if ([aglaUserRole]::isAdmin()) {
	write-sudo-messages;
}
