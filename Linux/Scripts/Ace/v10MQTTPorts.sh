#js

#JS 

#/WebSphere/scripts/middleware/ace/v10MQTTPorts.sh

#!/bin/bash

brk=$1
>/tmp/mqtt
echo -e "\n---- Name of the Broker = $brk"  >> /tmp/mqtt
echo -e "\n---- MQTT Port at Broker level "  >> /tmp/mqtt
mqsireportproperties $brk -b pubsub -o MQTTServer -r | grep -i port >> /tmp/mqtt

ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do      
   echo -e "----------------------------------------- Prop of mqtt $brk - $eg($ENO)"  >> /tmp/mqtt
   mqsireportproperties $brk -e $eg -o MQTT -r >> /tmp/mqtt
   ((ENO=ENO+1))
done 

echo -e "\n---- MQTT log for all brk, EG : "
cat /tmp/mqtt

echo -e "\n---- MQTT log - grep mqtt alone "
cat /tmp/mqtt | egrep 'serverURI|name'
