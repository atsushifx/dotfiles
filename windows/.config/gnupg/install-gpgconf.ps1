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

## Create the GNUPGHOME directory if it doesn't exist
New-Item -ItemType Directory -Path $env:GNUPGHOME -Force


# Create symbolic links for configuration files within GNUPGHOME
New-Item -ItemType SymbolicLink -Path "$env:GNUPGHOME\gpg.conf" -Target "${env:XDG_CONFIG_HOME}\gnupg\gpg.conf"
New-Item -ItemType SymbolicLink -Path "$env:GNUPGHOME\gpg-agent.conf" -Target "${env:XDG_CONFIG_HOME}\gnupg\gpg-agent.conf"
New-Item -ItemType SymbolicLink -Path "$env:GNUPGHOME\dirmngr.conf" -Target "${env:XDG_CONFIG_HOME}\gnupg\dirmngr.conf"


# Restart the gpg-agent to apply the new configuration
gpgconf --kill gpg-agent
