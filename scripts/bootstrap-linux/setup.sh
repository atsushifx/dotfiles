#!/usr/bin/env bash
#
# @(#) : dotfiles user setup script
#
# @version  1.0.0
# @since    2025-04-07
# @author   Furukawa Atsushi <atsushifx@gmail.com>
# @license  MIT
#
# @description <<
#
# This script performs user-level dotfiles setup:
#   - create ~/.config and ~/.editorconfig links
#   - create /opt/* links with sudo
#   - fix permissions
#   - append profile sourcing lines
#
# Usage:
#   ./setup.sh [--force] [--verbose]
#
#<<

set -euCo pipefail

### Constants
# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

### Global Variables
# Option Flags
FLAG_FORCE=false
FLAG_VERBOSE=false

### Functions
# Parse CLI options
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force)
        FLAG_FORCE=true
        ;;
      --verbose)
        FLAG_VERBOSE=true
        ;;
      *)
        echo "⚠️  Unknown option: $1" >&2
        exit 1
        ;;
    esac
    shift
  done
}

# Run a script with optional sudo and pass common flags
run_script() {
  local script="$1"
  local label="$2"
  local use_sudo=false

  shift 2
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --sudo)
        use_sudo=true
        ;;
    esac
    shift
  done

  echo "▶️  Running: $label"

  local args=()
  [[ "$FLAG_FORCE" == true ]] && args+=("--force")
  [[ "$FLAG_VERBOSE" == true ]] && args+=("--verbose")

  if [[ "$use_sudo" == true ]]; then
    if ! sudo bash -c ". \"$script\" ${args[*]}"; then
      echo "❌ Failed at: $label (sudo)" >&2
      exit 1
    fi
  else
    if ! . "$script" "${args[@]}"; then
      echo "❌ Failed at: $label" >&2
      exit 1
    fi
  fi
}

### Main routine
main() {
  parse_args "$@"

  echo "🛠  Starting dotfiles user setup..."

  run_script "$SCRIPT_DIR/create-user-links.sh" "Create user config links"
  run_script "$SCRIPT_DIR/create-opt-links.sh" "Create /opt links" --sudo
  run_script "$SCRIPT_DIR/fix-opt-permisson.sh" "Fix permissions for /opt"
  run_script "$SCRIPT_DIR/append-dotfiles-profile.sh" "Append dotfiles profile"

  echo "✅ Dotfiles user setup completed!"
}

### Only execute if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
