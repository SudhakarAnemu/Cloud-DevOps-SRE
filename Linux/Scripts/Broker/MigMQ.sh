#js

#/WebSphere/scripts/middleware/ace/MigMQ.sh qmgr brk ver


qmgr=$1
brk=$2
v12ver=$3

echo -e "Name of the qmgr : $1, Broker : $2, V12MQ : $3 -------------------------------------------"

echo -e "Setting v10 profile -------------------------------------------"
#setwmb 10
. /WebSphere/scripts/middleware/wmbprofile 10

echo -e "mqsilist of the brk"
mqsilist | grep $brk 

echo -e "dspmq of the qmgr"
dspmq -o all | grep $qmgr

echo -e "Health of the qmgr : -------------------------------------------"
/WebSphere/scripts/middleware/mqhealth.sh | grep $qmgr

echo -e "Stopping the Broker -------------------------------------------"
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop

echo -e "Stopping the QMGR -------------------------------------------"
endmqm -i $qmgr

echo -e "Process of Broker-------------------------------------------"
ps -ef | grep $brk

echo -e "Process of qmgr-------------------------------------------"
ps -ef | grep $qmgr

echo -e "Setting v12 profile -------------------------------------------"
#setwmb 12
. /WebSphere/scripts/middleware/wmbprofile 12

echo -e "Migrate qmgr to v12 -------------------------------------------"
setmqm -m $qmgr -n $v12ver

echo -e "Start the qmgr -------------------------------------------"
strmqm $qmgr

echo -e "Display the qmgr -------------------------------------------"
dspmq -o all | grep $qmgr