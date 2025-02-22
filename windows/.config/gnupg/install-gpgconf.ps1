## @(#):  set gpg configuration file's symbolic link to AppData
#
# @version  1.0.0
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @since    2025-02-20
# @license  MIT
#
# @desc<<
#
# This script sets up symbolic links for GnuPG configuration files in the
# user's AppData directory.
# because these configuration files are managed by dotfiles repository.
#
#<<

# Ensure the GNUPGHOME environment variable is set
$env:GNUPGHOME = "${env:APPDATA}\gnupg"

# Create the gnupg directory in AppData if it doesn't exist
New-Item -ItemType Directory -Path "${env:APPDATA}\gnupg" -Force

# Create symbolic links for configuration files
New-Item -ItemType SymbolicLink -Path "${env:APPDATA}\gnupg\gpg.conf" -Target "$env:USERPROFILE\.config\gnupg\gpg.conf"
New-Item -ItemType SymbolicLink -Path "${env:APPDATA}\gnupg\gpg-agent.conf" -Target "$env:USERPROFILE\.config\gnupg\gpg-agent.conf"
New-Item -ItemType SymbolicLink -Path "${env:APPDATA}\gnupg\dirmngr.conf" -Target "$env:USERPROFILE\.config\gnupg\dirmngr.conf"

gpgconf --kill gpg-agent
