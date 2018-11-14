#!/bin/bash

#todo capture EOF to leave script
#todo append command to log: done, but where should the log be? Should it have the user's name?
#todo ignore commands: done, but what about pipe?
#todo tab autocomplete
#todo empty command is being timed, probably should not be

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

trap ''  2

while true
do
  echo -n `logname`@`hostname`:`dirs +0`\$" "
	read CMD
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