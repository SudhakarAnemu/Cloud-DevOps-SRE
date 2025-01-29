#JS

#!/bin/bash
#/WebSphere/scripts/middleware/amsListLables.sh <jks> <pwd>
# JS - check details of Labels.

echo "First parameter (kdb) : $1"
echo "Second parameter (pwd) : $2"

echo -e "Certs under given kdb : $1 "
runmqakm -cert -list -db WMBMQTSTkey.kdb -pw WMBMQTST

runmqakm -cert -list -db $1 -pw $2 | grep -v found | grep -v "* default, - personal, ! trusted, # secret key" | awk -F " " '{print $2}' > /tmp/alllbls

SNO=1
while IFS= read -r line
do
   echo "SNO : $SNO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   echo "Name of the Label : $line"
   runmqakm -cert -details $1 -pw $2 -label $line | head
   ((SNO=SNO+1))
done < /tmp/alllbls


