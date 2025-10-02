JS 


#!/bin/bash
qmgr=$1
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
done < qlist







echo "DIS QL(AAAAAAAAAAAAAAAAAAA) DEFPSIST" | runmqsc MQTT > /tmp/del

cat /tmp/del | grep "DEFPSIST(" | awk -F"(" '{print $2}' | awk -F")" '{print $1}'
NO

extracted_value=$(cat /tmp/del | grep "DEFPSIST(" | awk -F"(" '{print $2}' | awk -F")" '{print $1}')



AAAAAAAAAAAAAAAAAAA


