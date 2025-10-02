js

#!/bin/bash
#/WebSphere/scripts/middleware/Files2Queue.sh qmgr queue file
export CLASSPATH=/WebSphere/wmqutil:/opt/mqm92/java/lib/com.ibm.mq.jar:%CLASSPATH%
qmgr=$1
queue=$2
echo -e "\nGiven QMGR : $qmgr, Queue : $queue"
SNO=1
for file in *.pub
do
    echo -e "\n File Number : $SNO -- Name : $file"
    /opt/mqm92/java/jre64/jre/bin/java -Djava.library.path=/opt/mqm92/java/lib64/ MQFile2Msg -q $queue -f $file -m $qmgr
    #sleep 1
    ((SNO=SNO+1))
done

----------------------------->> Post msg on File : 

#!/bin/bash
#/WebSphere/scripts/middleware/Files2Queue1File.sh qmgr queue file
export CLASSPATH=/WebSphere/wmqutil:/opt/mqm92/java/lib/com.ibm.mq.jar:%CLASSPATH%
qmgr=$1
queue=$2
file=$3
echo -e "\nGiven QMGR : $qmgr, Queue : $queue, File : $file"
/opt/mqm92/java/jre64/jre/bin/java -Djava.library.path=/opt/mqm92/java/lib64/ MQFile2Msg -q $queue -f $file -m $qmgr
 



---------------------------------->> 
/WebSphere/scripts/middleware/Files2Queue.sh IIBT1AA34 E.CUSA0.C_ESBPS_X_PS_ITCGPP.I


--> copy sw : 
scp varhdv122:/WebSphere/wmqutil/mh06.zip .



while IFS= read -r line
do
   echo "DIS QL($queue) DEFPSIST" | runmqsc $qmgr > /tmp/del
   psist=$(cat /tmp/del | grep "DEFPSIST(" | awk -F"(" '{print $2}' | awk -F")" '{print $1}')

   if [[ "$psist" == "NO" ]]; then
      echo "--------------NO"
   elif [[ "$psist" == "YES" ]]; then
      echo "--------------YES"
   else
      echo "-----------------None"
   fi
done < 