<#
	.SYNOPSIS
	key customize script

	.DESCRIPTION
	key function customize : config key of powershell command line
  default customize: wz (Wz/diamond cursor key)

	.NOTES
	@Author		Furukawa, Atsushi <atsushifx@aglabo.com>
	@License 	MIT License https://opensource.org/licenses/MIT

	@date		2023-05-31
	@Version 	1.0.0

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

<#
	.SYNOPSIS
    key customize like wz editor

	.DESCRIPTION
	key config/customize like WzEditor
	diamond key -> move cursor & history
	ctrl+p: select history with fzf and set command line to execute this.


  .EXAMPLE
    Set-PSReadLineKeyHandler -chord Ctrl+p -scriptBlock { SelectAndExecHistory }
    using above that hit ctrl+p to use this.

#>
function keyConfig_wzLike() {
	Set-PSReadLineOption -EditMode windows


	# windows default Ctrl+Shift+<Key>
	Set-PSReadLineKeyHandler -chord Ctrl+A -function SelectAll
	Set-PSReadLineKeyHandler -chord Ctrl+X -function cut
	Set-PSReadLineKeyHandler -chord Ctrl+C -function copy

	# exit shell
	$keyConfig_exit = @{
		BriefDescription = 'exit'
		LongDescription  = 'input exit {ENTER}'
		ScriptBlock      = {
			Execute_Command "exit" -send -enter
		}
	}
	Set-PSReadLineKeyHandler -chord Ctrl+Z @keyConfig_exit

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
	$keyConfig = @{
		BriefDescription = 'select & execute history'
		LongDescription  = 'select history with fzf & execute this'
		ScriptBlock      = { Execute_History -send }
	}

	Set-PSReadLineKeyHandler -chord Ctrl+p @keyConfig
	Set-PSReadLineKeyHandler -chord Ctrl+n -function NextHistory

	Set-PSReadLineKeyHandler -chord Ctrl+e -function PreviousHistory
	Set-PSReadLineKeyHandler -chord Ctrl+x -function NextHistory

	# zsh like tab completion
	# Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

keyConfig_wzLike

