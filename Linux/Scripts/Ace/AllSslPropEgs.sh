#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/AllSslPropEgs.sh
brk=$1
fno=$2
tag=$3
LOG=AllSSLProperties.$brk.$tag.$fno

>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "--------------------------------------------------------------------------------------------------------$tag Prop of  $brk - $eg($ENO)" >> $LOG
   echo -e "mqsireportproperties brk -e eg -o ComIbmJVMManager -r | grep store"  >> $LOG
   mqsireportproperties $brk -e $eg -o ComIbmJVMManager -r | grep store >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i port" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i port >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i Port" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i Port  >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i store" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i store >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i store" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i store >> $LOG
   echo -e "mqsireportproperties brk -e eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener" >> $LOG
   mqsireportproperties $brk -e $eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener >> $LOG
   echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a  | grep -i ssl" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -a  | grep -i ssl >> $LOG
   ((ENO=ENO+1))
done 