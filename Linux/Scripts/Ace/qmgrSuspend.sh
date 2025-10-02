#JS 

#/WebSphere/scripts/middleware/ace/qmgrSuspend.sh qmgr
#!/bin/bash
qmgr=$1

echo -e "\n-----------Current cluster status of the qmgr"
echo "dis clusqmgr($qmgr) suspend" | runmqsc $qmgr | grep -v AMQ8441 | grep -v MQSC | grep -v Copyright | grep -v commands

echo -e "-----------Suspending qmgrs w.r.t cluster names"

for cluster in `echo "dis clusqmgr($qmgr) suspend" | runmqsc $qmgr | grep CLUSTER | awk -F "(" '{print $2}' | awk -F")" '{print $1}'`;   do
    echo -e "\n\t---- Suspending for the cluster --$cluster--"
    echo "SUSPEND QMGR CLUSTER($cluster)" | runmqsc $qmgr
done

echo -e "\n-----------Current cluster status of the qmgr -- After suspending"
echo "dis clusqmgr($qmgr) suspend" | runmqsc $qmgr | grep -v AMQ8441 | grep -v MQSC | grep -v Copyright | grep -v commands
