# src: Documentation/powershell/completion.d/git-wt.ps1
# @(#) : worktrunk (git-wt) completion for powershell
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

if (command git-wt) {
  git-wt config shell init powershell | Out-String | Invoke-Expression
}
