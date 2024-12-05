#JS - It restarts the broker. 

# /WebSphere/scripts/middleware/brkrestart.sh

#!/bin/bash
brk=$1
echo -e "\n------------------------------------------------ Broker $brk is going to restart"
echo -e "\n------------------------------------------------Processes of the broker : "
ps -ef | grep $brk | grep bip
echo -e "\n------------------------------------------------Processes of the Execution groups : "
ps -ef | grep $brk | grep -i dataflow | sort -n
echo -e "\n------------------------------------------------Number of Execution groups : "
ps -ef | grep $brk | grep -i dataflow | sort -n | wc -l
echo -e "\n------------------------------------------------Stopping the Broker $brk : "
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop
sleep 15
echo -e "\n------------------------------------------------Processes of the broker After stopping : "
ps -ef | grep $brk | grep bip
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk start
sleep 15
echo -e "\n------------------------------------------------Processes of the broker After starting : "
ps -ef | grep $brk | grep bip
echo -e "\n------------------------------------------------Processes of the Execution groups : "
ps -ef | grep $brk | grep -i dataflow | sort -n
echo -e "\n------------------------------------------------Number of Execution groups : "
ps -ef | grep $brk | grep -i dataflow | sort -n | wc -l