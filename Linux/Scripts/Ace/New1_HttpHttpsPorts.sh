#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh
brk=$1
fno=$2
tag=$3
LOG=HttpHttpsPorts.$brk.$tag.$fno
>$LOG
ENO=1
flagHttps=0
flagHtp=0
#bport1=`mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
#bport2=`mqsireportproperties $brk -b httplistener -o HTTPConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
#echo -e "Broker:$brk-https:$bport1-http:$bport2" >> $LOG
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do      
   port1=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n port|grep -v BIP8071I|tr -d '\n'`
   port2=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`


   if [[ "$port1" -eq 0 && "$port2" -eq 0 ]]; then
      flagHttps=1
   fi


   port3=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n port|grep -v BIP8071I|tr -d '\n'`    
   port4=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`

   if [[ "$port3" -eq 0 && "$port4" -eq 0 ]]; then
      flagHtp=1
   fi

   echo -e "Eg:$eg-HTTPS:$port1-HTTPSexpl:$port2-HTTP:$port3-HTTPexpl:$port4" >> $LOG

   if [[ "$flagHttps" -eq 1 ]]; then
      echo -e "mqsichangeproperties $brk -e $eg -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
   fi   

   if [[ "$flagHtp" -eq 1 ]]; then
      echo -e "mqsichangeproperties $brk -e $eg -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
   fi   

   ((ENO=ENO+1))
done


