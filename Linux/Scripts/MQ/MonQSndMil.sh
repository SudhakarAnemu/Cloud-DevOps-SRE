#js 

#Input  QMNAME-Q1:Q2:Q3:Q4:Q5
#Input  V10TSTQM-QL1:QL2:QL3

#V10TSTQM-QL1:QL2:QL3
#V12TSTQM-QL11:QL12:QL13
#13TSTQM-QL21:QL22:QL23
#14TSTQM-QL31:QL32:QL33

#/WebSphere/scripts/middleware/MonQSndMil.sh <path of the file>

#!/bin/bash
#email='q17020@cusa.canon.com'
email='CUSA_WMB_Admins@cusa.canon.com,cfritz_consultant@cusa.canon.com,spolice_consultant@cusa.canon.com,sxu_consultant@cusa.canon.com'
host="QStat:`uname -n`"
. /WebSphere/scripts/middleware/wmbprofile 10
rm -rf /tmp/log /tmp/log1 /tmp/log2
log=/tmp/log
log1=/tmp/log1
mlog=/tmp/log2
>$log
>$mlog
>$log1
qlist=$1
SNO=1
echo "----------------------------------- Data was caputred at --$(date +%Y-%m-%d_%H-%M-%S)" >> $mlog

echo -e "\nFirst OP talks about Status of queue and second OP has curdepth and maxdepth" >> $mlog
echo -e "\nQueueManager-Queue1:Queue2:Queue3:Queue4:Queue5" >> $mlog
while IFS= read -r line
do
    >qs.mqsc
    seq=$line        
    echo -e "\nS.No : $SNO ---$seq---\n\n">> $mlog
    echo -e "\nS.No : $SNO ---$seq---"
    qmgr=`echo $seq | awk -F"-" '{print $1}'`
    echo -e "\nName of the qmgr : ---$qmgr---"
    qs=`echo $seq | awk -F"-" '{print $2}'`
    echo -e "\nName of the queues : ---$qs---"
    echo -e "\nList of queues"
    IFS=':' read -r -a array <<< "$qs"
    for j in "${array[@]}"; do
       echo "---$j---"
       echo "DIS QS($j)" >> qs.mqsc
       echo "DIS QL($j) CURDEPTH MAXDEPTH" >> qs.mqsc
    done    
    ((SNO=SNO+1))
    echo -e "\nLets list the content of qs.mqsc"
    cat qs.mqsc
    runmqsc $qmgr < qs.mqsc >> $log
    #runmqsc $qmgr < ql.mqsc >> $log1
done < $qlist

#echo "----------------------------------- Data was caputred at --$(date +%Y-%m-%d_%H-%M-%S)" >> $mlog

#cat $log | grep CURDEPTH -B 1 >> $mlog
#cat $log1 >> $mlog

cat $log |grep QUEUE -A 1 >> $mlog

#cat $mlog |grep QUEUE -A 1| grep -v AMQ8409 | grep -v AMQ8450 | grep -v MQSC | grep -v Copyright |mail -r "noreply-qstat@cusa.canon.com" -s "ALERT_Q_Prod:$host:$qmgr" "$email"

cat $mlog  |mail -r "noreply-qstat@cusa.canon.com" -s "ALERT_Q_Prod:$host:$qmgr" "$email"