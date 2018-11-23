#!/bin/bash

# month format: 11/2018

if [[ -z $1 ]]; then 
  echo "Should pass month"
  exit
fi

MONTH=$1

grep $MONTH /var/tmp/log | awk -F "\t" -v usrTime=0 -v sysTime=0 '{split($(NF-1),sys," "); sysTime+=sys[1]; split($(NF-2),usr," "); usrTime+=usr[1];} END {print "total user: ", usrTime; print "total sys: ", sysTime}'