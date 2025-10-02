#js
# 
# Developer : "Sudhakar Anemu" <sanemu_consultant@cusa.canon.com>

#v10status.sh <broker> Tag 
#/WebSphere/scripts/middleware/ace/ValidJKSHttpsAfterBkp.sh brk tag
#!/bin/bash

brk=$1
tag=$2

echo -e "\nS.No - 1 : $brk : $tag- Status of the Broker(Port) - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
mqsilist | grep $brk

echo -e "\nS.No - 3 : $brk : $tag- SSL(Key, Trust stores) - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
LOG=jksJvmHttps.$brk.$tag.3
>$LOG
/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 3 $tag > $LOG
cat $LOG
echo -e "\nS.No - 3.1 : $brk : $tag- SSL(Key, Trust stores) Not-exists - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
cat $LOG | grep 'Not-Exists'

echo -e "\nS.No - 3.2 : $brk : $tag- SSL(Key, Trust stores) exists - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
cat $LOG | grep -v 'Not-Exists'

echo -e "\nS.No - 4 : $brk : $tag- HTTPports - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
LOG=HttpHttpsPorts.$brk.$tag.4
>$LOG
/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh $brk 4 $tag > $LOG
echo -e "\nHTTP and HTTPs ports $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
cat $LOG

echo "---------------------------- Completed ----------------------------"