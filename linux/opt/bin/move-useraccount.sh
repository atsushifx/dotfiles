#!/usr/bin/env bash
#

## move default accpunt to new account
move_account() {
  local orgUser=$1
  local newUser=$2

  # move account
  /usr/sbin/usermod "${orgUser}" --login "${newUser}" --home "/home/${newUser}"

  # move home directory
  mv "/home/${orgUser}" "/home/${newUser}"

  # move /etc/group's account
  sed -e "s/:${orgUser}$/:${newUser}/g" /etc/group > /tmp/group.new
  mv /tmp/group.new /etc/group

  #
  echo "move ${orgUser} to ${newUser}" 
}


## Main
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  if [[ "$1" == "" ]]; then
    echo "$( basename $0) <oldAccount> <newAccount>"
  elif [[ "$#" == "1" ]]; then
    move_account "pwruser" "$1"
  else
    move_account "$1" "$2"
  fi
fi
