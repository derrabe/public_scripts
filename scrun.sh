#!/usr/bin/bash

today=$(date +%d_%m_%y)
#pwd
#parent_PWD=$(readlink -ve "/proc/$PPID/cwd")
#echo $parent_PWD

timingfile=timing_${today}
if [[ -e ${timingfile}.log ]] ; then
    i=0
    while [[ -e ${timingfile}_${i}.log ]] ; do
        let i++
    done
    timingfile="${timingfile}_${i}"
fi
timelog="${timingfile}.log"

logfile=log_${today}
if [[ -e ${logfile}.log ]] ; then
    i=0
    while [[ -e ${logfile}_${i}.log ]] ; do
        let i++
    done
    logfile="${logfile}_${i}"
fi
log="${logfile}.log"

script --timing=$timelog $log ; exec bash
