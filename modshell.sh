#!/bin/bash

#todo capture EOF to leave script
#todo echo PS1 done
#todo append command to log
#todo ignore commands: done, but what about pipe?
#todo tab autocomplete

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

while true
do
  echo -n `logname`@`hostname`:`dirs +0`\$" "
	read CMD
  MAIN_COMMAND=$(echo $CMD | awk '{print $1}')
  if containsElement $MAIN_COMMAND ${IGNORED_COMMANDS[@]}; then
    $CMD
  else
    /usr/bin/time -f "$CMD\t%e real,\t%U user,\t%S sys" -ao /var/tmp/log bash -c "$CMD"
  fi
done