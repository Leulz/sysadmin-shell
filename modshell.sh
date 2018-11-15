#!/bin/bash

#todo append command to log: done, but where should the log be? Should it have the user's name?
#todo empty command is being timed, probably should not be
#How to deal with piped commands that have both ignored and non-ignored commands?

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

trap 'echo "Command ignored, press <<Enter>> to continue.";continue' 2

while true
do
	read -e -p "`logname`@`hostname`:`dirs +0`\$ " CMD
  #If CMD is ^D, read will have exit code "1"
  if [[ $? == 1 ]]; then 
    trap 2
    echo ""
    exit
  fi

  MAIN_COMMAND=$(echo $CMD | awk '{print $1}')
  if containsElement $MAIN_COMMAND ${IGNORED_COMMANDS[@]}; then
    $CMD
  else
    /usr/bin/time -f "$CMD\t%e real,\t%U user,\t%S sys" -ao /var/tmp/log bash -c "$CMD"
  fi
done