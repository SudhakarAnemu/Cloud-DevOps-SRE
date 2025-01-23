#js 
#/WebSphere/scripts/middleware/dspmqsplAllQmgrs.sh
#!/bin/bash
LOG=/tmp/dspmqspl.log
>$LOG
for i in 9 10 12; 
do 
    . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null;    
    dspmq|awk -F"[(*)]" '{print  $2}'|while read qmgr; 
    do    
        echo "--- QMGR : $qmgr" >> $LOG
        dspmqspl -m $qmgr -export >> $LOG
    done; 
done
echo "-----------  Completed -----------"