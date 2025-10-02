js

------------------------->> Disable list of Qs for given QMGR. 

#/WebSphere/scripts/middleware/disableQlist.sh
#!/bin/bash
SNO=1
rm -rf disable.sh
while IFS= read -r line
do
   echo -e "\nS.No : $SNO - Before Q : ***$line***"   
   queue="${line//[[:space:]]/}"
   echo -e "\nS.No : $SNO - After Q : ***$queue***"
   echo "ALTER QL($queue) GET(DISABLED)" >> disable.sh
   ((SNO=SNO+1))
done < qlist

------------------------->> Enable list of Qs for given QMGR. 
#/WebSphere/scripts/middleware/enableQlist.sh
#!/bin/bash
SNO=1
rm -rf enable.sh
while IFS= read -r line
do
   echo -e "\nS.No : $SNO - Before Q : ***$line***"   
   queue="${line//[[:space:]]/}"
   echo -e "\nS.No : $SNO - After Q : ***$queue***"
   echo "ALTER QL($queue) GET(ENABLED)" >> enable.sh
   ((SNO=SNO+1))
done < qlist









 
echo "DIS QL(*) WHERE(PUT EQ DISABLED)" | runmqsc WASPRAD21  | grep QUEUE | awk -F"[(')]" '{print $2}' 


-------------------------------->> Enabled queues, start chl for one qmgr. 
enblq.sh /WebSphere/scripts/middleware/enblq.sh

#!/bin/bash
LOG=All.$(hostname).log.$(date "+%Y.%m.%d-%H.%M.%S")
QMGR=$1
rm -rf puten.sh
echo "Name of the qmgr : $QMGR"
echo "Qs which are put disabled : "
echo "DIS QL(*) WHERE(PUT EQ DISABLED) all" | runmqsc $QMGR >> $LOG
echo "DIS QL(*) WHERE(PUT EQ DISABLED)" | runmqsc $QMGR  | grep QUEUE | awk -F"[(')]" '{print $2}' > /tmp/putq
while IFS= read -r line
do
	echo "ALTER QL($line) PUT(ENABLED)" >> puten.sh
done < /tmp/putq
runmqsc $1 < puten.sh > puten.sh.out
 

-----------------> Enable Qs for all QMGRs : 


/WebSphere/scripts/middleware/enableputAllQmgrs.sh

#!/bin/bash
LOG=All.$(hostname).log.$(date "+%Y.%m.%d-%H.%M.%S")

for qmgr in `dspmq | awk -F"[(*)]" '{print $2}'`
do 
#QMGR=$1
   rm -rf puten.sh
   echo "Name of the qmgr : $qmgr"
   echo "Qs which are put disabled : "
   echo "DIS QL(*) WHERE(PUT EQ DISABLED) all" | runmqsc $qmgr >> $LOG
   echo "DIS QL(*) WHERE(PUT EQ DISABLED)" | runmqsc $qmgr  | grep QUEUE | awk -F"[(')]" '{print $2}' > /tmp/putq
   while IFS= read -r line
   do
	   echo "ALTER QL($line) PUT(ENABLED)" >> puten.sh
   done < /tmp/putq
   runmqsc $qmgr < puten.sh > puten.sh.out
done

--------------------------->> for multiple qmgrs : 

------------------> Start channel for a single QMGR : 

/WebSphere/scripts/middleware/startchl.sh

#!/bin/bash
LOG=All.$(hostname).log.$(date "+%Y.%m.%d-%H.%M.%S")
QMGR=$1
rm -rf puten.sh
>chlen.sh
echo "Name of the qmgr : $QMGR"
echo "Chls which are not in running state "
echo "DIS CHS(*) WHERE(STATUS NE RUNNING)" | runmqsc $QMGR >> $LOG
echo "DIS CHS(*) WHERE(STATUS NE RUNNING)" | runmqsc $QMGR | grep CHANNEL | awk -F"[(')]" '{print $2}' > /tmp/chl
while IFS= read -r line
do
	echo "STOP CHL($line)" >> chlen.sh 
	#echo "RESET CHL($line) SEQNUM(1)" >> chlen.sh
	echo "START CHL($line)" >> chlen.sh	
done < /tmp/chl
runmqsc $1 < chlen.sh > chlen.sh.out

-------------------------------> Restart channels for all qmgrs : 
/WebSphere/scripts/middleware/startchlAllQmgrs.sh

#!/bin/bash
LOG=All.$(hostname).log.$(date "+%Y.%m.%d-%H.%M.%S")

for qmgr in `dspmq | awk -F"[(*)]" '{print $2}'`
do 
   rm -rf chlen.sh
   >chlen.sh
   echo "-------- $qmgr ----" 
   echo "Name of the qmgr : $QMGR"
   echo "Chls which are not in running state "
   echo "DIS CHS(*) WHERE(STATUS NE RUNNING)" | runmqsc $qmgr >> $LOG
   echo "DIS CHS(*) WHERE(STATUS NE RUNNING)" | runmqsc $qmgr | grep CHANNEL | awk -F"[(')]" '{print $2}' > /tmp/chl
   while IFS= read -r line
   do
	   echo "STOP CHL($line)" >> chlen.sh 
	   #echo "RESET CHL($line) SEQNUM(1)" >> chlen.sh
	   echo "START CHL($line)" >> chlen.sh	
   done < /tmp/chl
   runmqsc $qmgr < chlen.sh > chlen.sh.out
done

------------------------------------------------> Prepare runmqsc for disable enable and disaplay qs. 

#Provide q's at the file : qlist

qmrunmqsc.sh

#!/bin/bash
SNO=1
rm -rf dispq.mqsc
rm -rf getdisable.mqsc
rm -rf getenable.mqsc
while IFS= read -r line
do
   echo -e "SNO : $SNO"
   echo "DIS QL($line) get put curdepth" >> dispq.mqsc
   echo "ALTER QL($line) GET(DISABLED)" >> getdisable.mqsc
   echo "ALTER QL($line) GET(ENABLED)" >> getenable.mqsc
   ((SNO=SNO+1))
done < qlist
