#!/usr/bin/env bash
#
# @(#) eakatime shell tracker
#
# @version  1.0.0
# @date     2023-04-30
# @author   wakatime
# @license  
#
# @desc <<
#
# wakatime plugin for bash
#
# include this file in your "~/.bashrc" file with this command:
#   . path/to/bash-wakatime.sh
#
# or this command:
#   source path/to/bash-wakatime.sh
#
# Don't forget to create and configure your "~/.wakatime.cfg" file.
#
#<<

# hook function to send wakatime a tick
wakatime_hb() {
    version="1.0.0"
    entity=$(echo $(fc -ln -0) | cut -d ' ' -f1)
    [ -z "$entity" ] && return # $entity is empty or only whitespace
    $(git rev-parse --is-inside-work-tree 2> /dev/null) && local project="$(basename $(git rev-parse --show-toplevel))" || local project="Terminal"
    (wakatime-cli --write --plugin "bash-wakatime/$version" --entity-type app --project "$project" --entity "$entity" 2>&1 > /dev/null &)
}

PROMPT_COMMAND="wakatime_hb; $PROMPT_COMMAND"
