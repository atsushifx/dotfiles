#!/usr/bin/env bash
#
# @(#) : setup user config links from dotfiles
#
# @version  1.0.1
# @author   Furukawa Atsushi
# @since    2025-04-07
# @license  MIT
#
# @description <<
# Create symbolic links:
#   ~/.local/dotfiles/linux/.config → ~/.config
#   ~/.config/.editorconfig         → ~/.editorconfig
#
# Use -f or --force to recreate links even if they exist.
#<<

set -euCo pipefail
readonly THISCMD="$0"
readonly SCRIPTDIR="$(cd "$(dirname "$0")"; pwd)"
readonly WORKINGDIR="$(pwd)"

FLAG_FORCE=false

parse_args() {
	for arg in "$@"; do
		case "$arg" in
			-f|--force)
				FLAG_FORCE=true
				;;
		esac
	done
}

create_user_links() {
	pushd "$HOME" > /dev/null
	local DOT_CONFIG="$HOME/.local/dotfiles/linux/.config"

	# Replace ~/.config if not a symlink or if --force is given
	if [[ "$FLAG_FORCE" == true || ! -L ~/.config ]]; then
		rm -rf ~/.config
		ln -s "$DOT_CONFIG" ~/.config
	fi

	# Link ~/.editorconfig if missing or --force is given
	if [[ "$FLAG_FORCE" == true || ! -e ~/.editorconfig ]]; then
		rm -f ~/.editorconfig
		ln -s ~/.config/.editorconfig ~/.editorconfig
	fi
  popd > /dev/null
}

## main routine
main() {
	parse_args "$@"
	create_user_links
}

