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
	- agBaseDir: base dir (Documents/powershell)
	- agLIBSDIR: common function library directory
	- agSCRIPTSDIR: common scripts directory


	.NOTES
#>

function Init_ScriptEnvironments() {
	# Guard against re-initialization: skip setup if already initialized
	if (Test-Path Variable:Global:agBaseDir) { return }

	Set-Variable -Scope Global -Option ReadOnly -Name agBaseDir -Value (Split-Path -Path $PROFILE)
	Set-Variable -Scope Global -Option ReadOnly -Name agLIBSDIR -Value $agBaseDir'/libs/' -Description 'common libs directory'
	Set-Variable -Scope Global -Option ReadOnly -Name agSCRIPTSDIR -Value $agBaseDir'/scripts/' -Description 'Common scripts directory'
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

## exec function
Init_ScriptEnvironments
