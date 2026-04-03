<#
  .SYNOPSIS
    volta tab completion for powershell

  .DESCRIPTION
    set up volta tab completion function for powershell.
    this function set up from `volta completions`

  .NOTES
    @Author   Furukawa, Atsushi <atsushifx@aglabo.com>
    @License  MIT License https://opensource.org/licenses/MIT

    @date     2023-05-31
    @Version  1.0.0

THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND.
THE ENTIRE RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>

volta completions powershell | Out-String | Invoke-Expression
