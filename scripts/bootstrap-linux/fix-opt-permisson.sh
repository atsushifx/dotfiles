#!/usr/bin/env bash
#
# @(#) : Adjust permissions and ownership for shared dotfiles under /opt
#
# @version  1.0.0
# @author   Furukawa Atsushi <atsushifx@aglabo.com>
# @since    2025-04-07
# @license  MIT
#
# @desc<<
#
# Sets proper permissions and group ownership for 'bin' (775) and 'etc' (664)
# under ~/.local/dotfiles/linux/opt/, which are symlinked to /opt.
# Enables shared access and collaboration via the 'wheel' group..
#
#<<

echo "🔧 Fixing permissions in dotfiles opt..."

TARGET="${HOME}/.local/dotfiles/linux/opt"

echo "🔁 chgrp -R wheel ..."
chgrp -R wheel "$TARGET"

# Set 775 permissions and setgid on all directories
find "$TARGET" -type d -exec chmod 2775 {} \;

# Set 775 on executable files under 'bin'
if [ -d "$TARGET/bin" ]; then
  echo "⚙️ Setting 775 permissions for executable files in 'bin/'..."
  find "$TARGET/bin" -type f -exec chmod 775 {} \;
fi

# Set 664 on config files under 'etc'
if [ -d "$TARGET/etc" ]; then
  echo "📝 Setting 664 permissions for config files in 'etc/'..."
  find "$TARGET/etc" -type f -exec chmod 664 {} \;
fi

echo "✅ Permissions fixed for: $TARGET"
