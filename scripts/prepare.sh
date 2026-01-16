#!/usr/bin/env bash
## src: ./scripts/prepare.sh
# @(#) : Install lefthook in local development environment only
#
# Copyright (c) 2025 atsushifx <http://github.com/atsushifx>
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT
#

# Function to determine if running in CI environment
is_ci_environment() {
  # Check common CI environment variables
  [ -n "$CI" ] ||             # Generic CI environment variable
  [ -n "$GITHUB_ACTIONS" ] || # GitHub Actions
  [ -n "$GITLAB_CI" ] ||      # GitLab CI
  [ -n "$CIRCLECI" ] ||       # CircleCI
  [ -n "$JENKINS_HOME" ] ||   # Jenkins
  [ -n "$TRAVIS" ]            # Travis CI
}

# Main processing
main() {
  if is_ci_environment; then
    echo "CI environment detected. Skipping lefthook install."
    exit 0
  fi

  if lefthook check-install ; then
    echo "lefthook is already installed."
    exit 0
  fi

  echo "Local development environment detected. "
  # Setup for local development environment
  lefthook install
  # remember bd hooks must set Git config set: core.hooksPath=.beads-hooks
  # bd hooks install --chain  --shared --no-daemon

}

main
