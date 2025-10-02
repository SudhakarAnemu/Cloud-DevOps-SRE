#JS - It restarts the broker. 

# /WebSphere/scripts/middleware/BRKRestart.sh


#!/bin/bash
brk=$1
free -m
echo -e "\n------------------------------------------------ Broker $brk is going to restart - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "\n------------------------------------------------Processes of the broker : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep bip
echo -e "\n------------------------------------------------Processes of the Execution groups : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep -i dataflow | sort -n
echo -e "\n------------------------------------------------Number of Execution groups : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep -i dataflow | sort -n | wc -l
echo -e "\n------------------------------------------------Stopping the Broker $brk : - $(date +%Y-%m-%d_%H-%M-%S)"
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop
sleep 10
echo -e "\n------------------------------------------------Processes of the broker After stopping : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep bip
perl /WebSphere/scripts/middleware/wmbRestart.pl $brk start
sleep 10
echo -e "\n------------------------------------------------Processes of the broker After starting : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep bip
echo -e "\n------------------------------------------------Processes of the Execution groups : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep -i dataflow | sort -n
echo -e "\n------------------------------------------------Number of Execution groups : - $(date +%Y-%m-%d_%H-%M-%S)"
ps -ef | grep $brk | grep -i dataflow | sort -n | wc -l
free -m

echo -e "-------------------Completed-------------------"

-----------> Restart for given arry : 

