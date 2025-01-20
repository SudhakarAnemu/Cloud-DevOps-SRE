#js 

#Input  QMNAME-Q1:Q2:Q3:Q4:Q5
#Input  V10TSTQM-QL1:QL2:QL3

#V10TSTQM-QL1:QL2:QL3
#V12TSTQM-QL11:QL12:QL13
#13TSTQM-QL21:QL22:QL23
#14TSTQM-QL31:QL32:QL33

#!/bin/bash
log=maillog
>$log
qlist=$1
SNO=1
echo "Data was caputred on --$(date +%Y-%m-%d_%H-%M-%S)" >> $log
while IFS= read -r line
do
    >qs.mqsc
    seq=$line        
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
    done    
    ((SNO=SNO+1))
    echo -e "\nLets list the content of qs.mqsc"
    cat qs.mqsc
    runmqsc $qmgr < qs.mqsc >> $log
done < $qlist


