#!/usr/bin/env bash
#
##  @(#) : create symlinks from dotfiles opt/* to system /opt/*
#
# @version  1.0.1
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @since    2025-04-07
# @license  MIT
#
# @description <<
#
# This script creates symbolic links from:
#   ~/.local/dotfiles/linux/opt/* → /opt/*
#
# Options:
#   -f    force overwrite if /opt/* already exists
#   -v    verbose output (show link creation)
#
# Run with sudo.
#
###
#
# THIS CODE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND.
# USE AT YOUR OWN RISK.
#
#<<

### initialize
set -euCo pipefail

### Global options
FLAG_VERBOSE=false
FLAG_FORCE=false

### functions

# get options from arguments
parse_args() {
	while getopts "vfh?" OPT; do
		case "$OPT" in
		v) FLAG_VERBOSE=true ;;
		f) FLAG_FORCE=true ;;
		esac
	done
	shift $((OPTIND - 1))
}

# Create symlinks from ~/.local/dotfiles/linux/opt/* to /opt/*
create_opt_symlinks() {
	readonly SRC_DIR="${HOME}/.local/dotfiles/linux/opt"
	local ENTRY NAME TARGET

  # check if $SRC_DIR is null or empty
  if ! compgen -G "$SRC_DIR/*" > /dev/null; then
		echo "⚠️  No entries found in $SRC_DIR. Skipped."
		return 1
	fi

	echo "🔗 Linking dotfiles from: $SRC_DIR → /opt/"

	for ENTRY in "$SRC_DIR"/*; do
		NAME=$(basename "$ENTRY")
		TARGET="/opt/$NAME"

		if [[ -e "$TARGET" || -L "$TARGET" ]]; then
			if [[ "$FLAG_FORCE" == true ]]; then
				rm -rf "$TARGET"
				[[ "$FLAG_VERBOSE" == true ]] && echo "❌ Removed existing $TARGET"
			else
				[[ "$FLAG_VERBOSE" == true ]] && echo "⚠️  $TARGET exists. Skipped."
				continue
			fi
		fi

		ln -s "$ENTRY" "$TARGET"
		[[ "$FLAG_VERBOSE" == true ]] && echo "📎 Linked: $TARGET → $ENTRY"
	done

	echo "✅ Symlink creation complete."
  return 0
}


### main routine
main() {
	parse_args "$@"
	create_opt_symlinks
}

main "$@"

