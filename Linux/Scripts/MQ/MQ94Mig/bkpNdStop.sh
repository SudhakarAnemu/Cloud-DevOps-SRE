JS



#!/bin/bash
#jsbkpNdStop.sh brk qmgr
brk=$1
qmgr=$2
bkpdir=/tmp/jsmq/
cd /var/mqm/qmgrs/
tar -cvf $bkpdir/$qmgr.qmgrfs.tar $qmgr
cd $bkpdir
dmpmqcfg -m $qmgr -t all -x all -o mqsc -a -o 1line > $qmgr.mqsc
amqoamd -m $qmgr -s > $qmgr.auth
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop;
endmqm -i $qmgr
sleep 5
ps -ef | grep $qmgr
ps -ef | grep $brk


--------------------------------------------------------------> Final script

#!/bin/bash
#moveQmgrsToV94.sh brk qmgr inst
brk=$1
qmgr=$1
inst=$3

. /WebSphere/scripts/middleware/wmbprofile 10

bkpdir=/tmp/jsmq/
cd /var/mqm/qmgrs/
tar -cvf $bkpdir/$qmgr.qmgrfs.tar $qmgr
cd $bkpdir
dmpmqcfg -m $qmgr -t all -x all -o mqsc -a -o 1line > $qmgr.mqsc
amqoamd -m $qmgr -s > $qmgr.auth
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop;
endmqm -i $qmgr
sleep 5
ps -ef | grep $qmgr
ps -ef | grep $brk

sleep 5

. /WebSphere/scripts/middleware/wmbprofile 9
. /WebSphere/scripts/middleware/wmbprofile 12

dspmq -o all | grep $qmgr
setmqm -m $qmgr -n $inst
strmqm $qmgr

sleep 5

dspmq -o all | grep $qmgr
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk start;
ps -ef | grep $brk

