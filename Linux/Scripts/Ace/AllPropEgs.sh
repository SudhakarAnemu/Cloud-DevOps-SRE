#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/AllPropEgs.sh
brk=$1
fno=$2
tag=$3
LOG=AllPropEgs.$brk.$tag.$fno

>$LOG
ENO=1

echo -e "-----------------------------BrokerRegistry of the Broker"  >> $LOG
mqsireportproperties $brk -o BrokerRegistry -r >> $LOG
echo -e "-----------------------------SecurityCache of the Broker"  >> $LOG
mqsireportproperties $brk -o SecurityCache -r >> $LOG

for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "--------------------------------------------------------------------------------------------------------$tag Prop of  $brk - $eg($ENO)" >> $LOG

   echo -e "-----------------------------AllReportableEntityNames of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o "AllReportableEntityNames" -r >> $LOG
   echo -e "-----------------------------ComIbmJVMManager of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o ComIbmJVMManager -r >> $LOG
   echo -e "-----------------------------HTTPConnector of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r >> $LOG
   echo -e "-----------------------------HTTPSConnector of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r >> $LOG
   echo -e "-----------------------------ExecutionGroup of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o ExecutionGroup -r >> $LOG
   echo -e "-----------------------------Kafka of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o Kafka -r >> $LOG
   echo -e "-----------------------------MQ of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o MQ -r >> $LOG
   echo -e "-----------------------------MQTT of $eg"  >> $LOG
   mqsireportproperties $brk -e $eg -o MQTT -r >> $LOG

   ((ENO=ENO+1))
done 