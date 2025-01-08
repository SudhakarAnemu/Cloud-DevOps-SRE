
#js Sudhakar Anemu

#MaxThread2Prop.sh <broker> Tag 
#/WebSphere/scripts/middleware/ace/MaxThread2Prop.sh brk tag
#!/bin/bash

brk=$1
LOG=MaxThread2Prop.$(date +%Y-%m-%d_%H-%M-%S)

echo -e "\nS.No 1 : $brk : MaxConnections of Egs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------"
LOG=maxThreads.$brk
>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "HTTPConnector - MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i MaxConnections  >> $LOG
   echo -e "HTTPSConnector - MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i MaxConnections  >> $LOG
   ((ENO=ENO+1))
done  

echo -e "\nS.No - 2 : $brk : ListenerThreads of Egs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------"
LOG=ListenerThreads.$brk
>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "HTTPConnector - MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i ListenerThreads  >> $LOG
   echo -e "HTTPSConnector - MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i ListenerThreads  >> $LOG
   ((ENO=ENO+1))
done  



