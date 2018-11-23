#!/bin/bash

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')
COMMAND_SEPARATORS=("&" "|" ";")

history -c -r "$HOME/.modshell_history"

#If the command to be ran is a shell builtin, it should not be timed.
#That only happens if the command is the builtin by itself without any separator (see function below)
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

#If the command to be ran contains one of the command separators,
#it should be timed, otherwise the user could just do something like "cd . && [...]"
#and execute whatever he wanted without the command being written in the logs.
containsSeparator() {
  for sep in "${COMMAND_SEPARATORS[@]}"
  do
    if [[ "$1" =~ "$sep" ]]; then
      return 0
    fi
  done
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
    break
  fi

  #If CMD is empty
  if [[ -z $CMD ]]; then
    continue
  fi

  history -s "$CMD"

  MAIN_COMMAND=$(echo $CMD | awk '{print $1}')
  if containsElement $MAIN_COMMAND ${IGNORED_COMMANDS[@]} && ! containsSeparator $CMD; then
    $CMD
  else
    MONTH_DATE=`date +\%m/%Y`
    /usr/bin/time -f "$CMD,\t%e real,\t%U user,\t%S sys,\t$MONTH_DATE" -ao /var/tmp/log bash -c "$CMD"
  fi
done

history -a "$HOME/.modshell_history"