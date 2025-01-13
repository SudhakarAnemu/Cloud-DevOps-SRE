#js

#/WebSphere/scripts/middleware/ace/MigMQ.sh qmgr brk ver


qmgr=$1
brk=$2
v12ver=$3

LOG=$qmgr.QMGRMig.log.$(date +%Y-%m-%d_%H-%M-%S)

echo -e "Name of the qmgr : $1, Broker : $2, V12MQ : $3 -------------------------------------------" >> $LOG

echo -e "Setting v10 profile -------------------------------------------" >> $LOG
#setwmb 10
. /WebSphere/scripts/middleware/wmbprofile 10

echo -e "\nHealth of the qmgr : " >> $LOG

/WebSphere/scripts/middleware/mqhealth.sh | grep $qmgr >> $LOG

/WebSphere/scripts/middleware/qmgrSuspend.sh $qmgr >> $LOG

echo -e "mqsilist of the brk" >> $LOG
mqsilist | grep $brk  >> $LOG

echo -e "dspmq of the qmgr" >> $LOG
dspmq -o all | grep $qmgr >> $LOG

echo -e "Health of the qmgr : -------------------------------------------" >> $LOG
/WebSphere/scripts/middleware/mqhealth.sh | grep $qmgr >> $LOG

echo -e "Stopping the Broker -------------------------------------------" >> $LOG
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop >> $LOG

echo -e "Stopping the QMGR -------------------------------------------" >> $LOG
endmqm -i $qmgr >> $LOG

echo -e "Process of Broker-------------------------------------------" >> $LOG
ps -ef | grep $brk >> $LOG

echo -e "Process of qmgr-------------------------------------------" >> $LOG
ps -ef | grep $qmgr >> $LOG

echo -e "Setting v12 profile -------------------------------------------" >> $LOG
#setwmb 12
. /WebSphere/scripts/middleware/wmbprofile 12

echo -e "Migrate qmgr to v12 -------------------------------------------" >> $LOG
setmqm -m $qmgr -n $v12ver >> $LOG

echo -e "Start the qmgr -------------------------------------------" >> $LOG
strmqm $qmgr >> $LOG

echo -e "Display the qmgr -------------------------------------------" >> $LOG
dspmq -o all | grep $qmgr >> $LOG

echo "---------------------------------------- Completed ----------------------------------------"