# src: scripts/pwsh-lint.ps1
# @(#) : PowerShell Lint executer
#
# Copyright (c) 2025 Furukawa Atsushi <atsushifx@gmail.com>
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# --- 実行
Invoke-ScriptAnalyzer -Settings ($agSCRIPTSDIR + '/settings/PSScriptAnalyzerSettings.psd1') @args
