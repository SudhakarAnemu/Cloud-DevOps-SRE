js




#!/bin/bash
#migQm94.sh qmgr inst
qmgr=$1
inst=$2
dspmq -o all | grep $qmgr
setmqm -m $qmgr -n $inst
strmqm $qmgr
dspmq -o all | grep $qmgr

