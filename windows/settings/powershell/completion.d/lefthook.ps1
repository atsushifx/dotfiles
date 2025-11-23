# src: Documentation/powershell/completion.d/lefthook.ps1
# @(#) : lefthook completion for powershell
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

lefthook completion pwsh | Out-String | Invoke-Expression
