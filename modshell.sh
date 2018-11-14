#!/bin/bash

#todo capture EOF to leave script
#todo echo PS1 done
#todo append command to log
#todo cd case skip
#todo ignore commands

IGNORED_COMMANDS=$(help | awk 'NR > 15 {print $1}')

while true
do
	read CMD
	echo -n `logname`@`hostname`:`dirs +0`\$" "
	(time $CMD) 2>>/var/tmp/log
done