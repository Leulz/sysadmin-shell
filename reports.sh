#!/bin/bash

# month format: 11/2018

if [[ -z $1 ]]; then 
  echo "Should pass month. Ex: reports.sh 11/2018"
  exit
fi

MONTH=$1

grep $MONTH /var/tmp/log | awk -F "\t" -v usrTime=0 -v sysTime=0 '
{split($(NF-1),sys," "); sysTime+=sys[1]; split($(NF-2),usr," "); usrTime+=usr[1];} 
END {print "total user: ", usrTime; print "total sys: ", sysTime}'

grep $MONTH /var/tmp/log | sed 's/\\;\|\\&\|\\|/=/g' | awk -F'[|&;]' '{for(i=1;i<=NF;i++) print $i}' | awk '$1 ~ /^[0-9a-zA-Z]+$/ {print $1}' | sort | uniq -c
