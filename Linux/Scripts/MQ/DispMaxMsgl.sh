#js 

#!/bin/bash

rm -rf /tmp/qmgrs
rm -rf /tmp/log
log=/tmp/log
dspmq|awk -F"[(*)]" '{print  $2}' > /tmp/qmgrs
SNO=1
while IFS= read -r line
do   
   qmgr=$line
   echo -e "\nS.No : $SNO - Name of the qmgr : $qmgr" >> $log
   echo -e "\nS.No : $SNO - Name of the qmgr : $qmgr"
   echo -e "\n--------------------------Maxmsgl of the QMGR : " >> $log
   echo "dis qmgr maxmsgl" | runmqsc $qmgr | grep MAXMSGL  >> $log
   echo -e "\n--------------------------Maxmsgl of the Channels : "  >> $log
   echo "dis chl(*) maxmsgl"  | runmqsc $qmgr | egrep "CHANNEL|MAXMSGL"  >> $log
   echo -e "\n--------------------------Maxmsgl of the Queues : "  >> $log
   echo "dis ql(*) maxmsgl"|runmqsc $qmgr| egrep "QUEUE|MAXMSGL"  >> $log
   ((SNO=SNO+1))
done < /tmp/qmgrs













rm -rf /tmp/qllist
listOfQs=/tmp/qllist
>$listOfQs














echo -e "\n-------------------------------------------------------- List of Local queues with Maxmsgl"
echo "dis ql(*)" | runmqsc $qmgr | grep QUEUE |  grep -v SYSTEM | awk -F "(" '{print $2}' | awk -F ")" '{print $1}' > /tmp/ql
while IFS= read -r line
do   
   qlmaxmsgl=`echo "dis ql($line) maxmsgl" | runmqsc $qmgr | grep MAXMSGL | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
   echo -e "$line---$qlmaxmsgl"
   #echo "dis ql($line) maxmsgl" | runmqsc $qmgr | egrep "QUEUE|MAXMSGL" | tr -d '\n' >> $listOfQs
   #echo "-----------" >> $listOfQs
done < /tmp/ql


echo -e "\n-------------------------------------------------------- List of Channels with Maxmsgl"
echo "dis chl(*)" | runmqsc $qmgr | grep CHANNEL | grep -v SYSTEM | awk -F "(" '{print $2}' | awk -F ")" '{print $1}' > /tmp/chl
while IFS= read -r line
do   
   chlmaxmsgl=`echo "dis chl($line) maxmsgl" | runmqsc $qmgr | grep MAXMSGL | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
   echo -e "$line---$chlmaxmsgl"
done < /tmp/chl

S21IB.ESTORE.INBOUND.PARALLEL.DATAGRAM---QLOCAL

echo "dis ql(S21IB.ESTORE.INBOUND.PARALLEL.DATAGRAM) maxmsgl" | runmqsc IIBDVAA34 | grep MAXMSGL | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`