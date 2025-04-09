#!/usr/bin/env bash
#
# @(#) : append dotfiles profile sourcing to /etc/profile and ~/.profile
#
# @version  1.2.0
# @since    2025-04-07
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @license  MIT
#
# @description<<
#
# Appends sourcing lines for dotfiles profiles to:
#   - /etc/profile (system-wide) with --system option
#   - ~/.profile   (user-specific) always
#
# The script ensures idempotency by checking for existing markers.
#
#<<

set -euCo pipefail

### Constants
readonly SYSTEM_PROFILE="/etc/profile"
readonly USER_PROFILE="${HOME}/.profile"
readonly DOTFILES_SYSTEM="/opt/etc/profile"
readonly DOTFILES_USER="${XDG_CONFIG_HOME:-$HOME/.config}/profile"

### Global options
FLAG_SYSTEM=false

### Functions

# get options from arguments
parse_args() {
	for arg in "$@"; do
		case "$arg" in
			-s|--system)
				FLAG_SYSTEM=true
				;;
		esac
	done
}

# Append content to a file if the marker is not already present
append_if_missing() {
	local target_file="$1"
	local marker="$2"
	local content="$3"

	if grep -qF "$marker" "$target_file" 2>/dev/null; then
		echo "✅ Marker already exists in $target_file. Skipping."
	else
		echo "📎 Appending to $target_file..."
		if ! echo -e "\n# $marker\n$content" >> "$target_file"; then
			echo "❌ Failed to write to $target_file" >&2
			return 1
		fi
	fi
  return 0
}

### main routine
main() {
	parse_args "$@"

	# System-wide profile (if --system is set)
	if [[ "$FLAG_SYSTEM" == true ]]; then
		if [[ -w "$SYSTEM_PROFILE" ]]; then
			append_if_missing "$SYSTEM_PROFILE" \
				"DOTFILES_PROFILE: system" \
				"[[ -f \"$DOTFILES_SYSTEM\" ]] && . \"$DOTFILES_SYSTEM\""
		else
			echo "❌ No write permission to $SYSTEM_PROFILE. Use sudo." >&2
			exit 1
		fi
	else
		echo "ℹ️  Skipping system profile update (/etc/profile)"
	fi

	# User profile
	append_if_missing "$USER_PROFILE" \
		"DOTFILES_PROFILE: user" \
		"[[ -f \"$DOTFILES_USER\" ]] && . \"$DOTFILES_USER\""

	echo "✅ Profile sourcing appended successfully."
}

main "$@"
