#!/bin/bash

#todo capture EOF to leave script
#todo echo PS1 done
#todo append command to log
#todo cd case skip
#todo ignore commands: done, but what about pipe?

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
    (time $CMD) 2>>/var/tmp/log
  fi
done