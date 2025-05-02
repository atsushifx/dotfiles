#!/usr/bin/env bash
#
# @(#) : setup user config links from dotfiles
#
# @version  1.0.1
# @author 	Furukawa Atsushi
# @since  	2025-04-07
# @license 	MIT
#
# @description <<
#
# Create symbolic links:
#   ~/.local/dotfiles/linux/.config → ~/.config
#   ~/.config/.editorconfig         → ~/.editorconfig
#
# Use -f or --force to recreate links even if they exist.
#
#<<

set -euCo pipefail

### Constants

readonly THISCMD="$0"
readonly SCRIPTDIR="$(cd "$(dirname "$0")"; pwd)"
readonly WORKINGDIR="$(pwd)"

### Global Variables

# options
FLAG_FORCE=false

### Functions
# get options from args
parse_options() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--force)
        FLAG_FORCE=true
        shift
        ;;
      *)
        echo "Usage: $THISCMD [-f|--force]"
        exit 1
        ;;
    esac
  done
}

# user link main
create_user_links() {
  pushd "$HOME" > /dev/null
  local DOT_CONFIG=".local/dotfiles/linux/config"

  echo "🔗 linking ~/bin"
  local DOT_LINUX_BIN=".local/dotfiles/linux/bin"
  if [ $FLAG_FORCE =="  true" ] || [ ! -L ~/bin ]; then
    rm -rf ~/bin
    ln -s "$DOT_LINUX_BIN" "~/bin"
  fi

  echo "🔗 linking ~/.config"
  if [ $FLAG_FORCE =="  true" ] || [ ! -L ~/.config ]; then
    rm -rf ~/.config
    ln -s "$DOT_CONFIG" ~/.config
  fi

  echo "🔗 linking ~/.editorconfig"
  if [ $FLAG_FORCE == "true" ] || [ -e ~/.editorconfig ]; then
    rm -f ~/.editorconfig
    ln -s ~/.config/.editorconfig ~/.editorconfig
  fi

  popd >/dev/null
}

## main routine
main() {
  create_user_links
}

main
