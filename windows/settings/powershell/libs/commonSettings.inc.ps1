<#
	.SYNOPSIS
    frequency use functions library

	.DESCRIPTION
	script common settings:
	set up script common constants /
	adminCheck

	.NOTES
	@Author		Furukawa, Atsushi <atsushifx@aglabo.com>
	@License	MIT License https://opensource.org/licenses/MIT

	@date		2023-05-31
	@Version	1.0.1

	script common settings & common use functions
	set default constants about common Libraries directory, scripts directory, ...


THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

#>
Set-StrictMode -version latest


## Set common Constants

<#
	.SYNOPSIS
	set powershell script common constants

	.DESCRIPTION
	set common constants variable for powershell script
	- THISCMD: script name
	- LIBSDIR: common function library directory
	- SCRIPTSDIR: common scripts directory
	- WORKINGDIR: script execution directory

	.NOTES
#>

function setupScriptCommonConstants() {
	$baseDir = (Split-Path -Path $PROFILE)
	set-Variable -Scope Global -Option ReadOnly -Name THISCMD -Value (Split-Path -Leaf $MyInvocation.PSCommandPath) -Description "executes command"
	Set-Variable -Scope Global -Option ReadOnly -Name LIBSDIR -Value $baseDir'/libs/' -Description 'common libs directory'
	Set-Variable -Scope Global -Option ReadOnly -Name SCRIPTSDIR -Value $baseDir'/scripts/' -Description 'Common scripts directory'
}

<#
	.SYNOPSIS
	check user role class

	.DESCRIPTION
	check script works by WindowsBuiltinRole: User/PowerUser/Administrator
	method:isAdmin checks user works as administrator

	.NOTES
 #>
class aglaUserRole {
	hidden static [Security.Principal.WindowsPrincipal]  $principal = [aglaUserRole]::getCurrentPrincipal()

	# get current windows principal
	hidden static [Security.Principal.WindowsPrincipal] getCurrentPrincipal() {
		$id = [Security.Principal.WindowsIdentity]::GetCurrent()
		$pr = [Security.Principal.WindowsPrincipal] $id
		return $pr
	}


	<#
      .SYNOPSIS
        check current user has role parameter

      .PARAMETER
        $role
        user role (Administrator, User, ...)
    #>
	static [bool]  hasRole([Security.Principal.WindowsBuiltInRole] $role) {
		return [aglaUserRole]::principal.IsInRole([Security.Principal.WindowsBuiltinRole] $role)
	}

	<#
      check user as 'Administrator'
    #>
	static [bool]  isAdmin() {
		return [aglaUserRole]::hasRole([Security.Principal.WindowsBuiltinRole]::Administrator)
	}
}
