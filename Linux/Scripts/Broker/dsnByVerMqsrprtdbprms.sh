#js


#!/bin/bash
#/WebSphere/scripts/middleware/dsnByVerMqsrprtdbprms.sh
output=/tmp/ouput
>$output
for ver in 10 12
do
      . /WebSphere/scripts/middleware/wmbprofile $ver >> /dev/null
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
         echo -e "\nI am working for --- Version : $ver ---- Broker : $brk"
         echo -e "\n--- Version : $ver ---- Broker : $brk\n" >> $output
         mqsireportdbparms $brk -n \* > /tmp/del
         cat /tmp/del | awk -F " " '{print $5 " -- " $8}' | grep -v ignore >> $output
      done
done
echo -e "\n----------- Brokers, Version and DSN with uid's "
cat -n $output