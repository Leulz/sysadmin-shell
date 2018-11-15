#!/bin/bash -i

#todo append command to log: done, but where should the log be? Should it have the user's name?
#todo empty command is being timed, probably should not be
#How to deal with piped commands that have both ignored and non-ignored commands?

# The following may be useful:
# TIMEFORMAT="$CMD"$'\t%E real,\t%U user,\t%S sys'
# exec 3>&1 4>&2
# { time $CMD 1>&3 2>&4; } >/var/tmp/log 2>&1 
# exec 3>&- 4>&-

#Currently, when timing the command, we use the flags -c and -i. -i forces .bashrc to be loaded. 
#Is there a better way? Also, we should load .profile too.

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')
history -c -r "$HOME/.modshell_history"

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
    break
  fi

 history -s "$CMD"

  MAIN_COMMAND=$(echo $CMD | awk '{print $1}')
  if containsElement $MAIN_COMMAND ${IGNORED_COMMANDS[@]}; then
    $CMD
  else
    /usr/bin/time -f "$CMD\t%e real,\t%U user,\t%S sys" -ao /var/tmp/log bash -ci "$CMD"
  fi
done

history -a "$HOME/.modshell_history"