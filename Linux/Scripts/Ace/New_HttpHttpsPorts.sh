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
   #echo -e "\nport1 == ---$port1---EG: --$eg--"
   if [[ "$port1" -eq 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHttps=1
   fi
   if [[ "$port1" -ne 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHttps=0
   fi   
   port2=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   #echo -e "\nport2 == ---$port2---EG: --$eg--"
   if [[ "$port2" -eq 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHttps=1
   fi
   if [[ "$port2" -ne 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHttps=0
   fi   
   #if [[ "$port1" -eq 0 && "$port2" -eq 0 ]]; then
   #   flagHttps=0
   #fi
   port3=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n port|grep -v BIP8071I|tr -d '\n'`
   #echo -e "\nport3 == ---$port3---"
   if [[ "$port3" -eq 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHtp=1
   fi   
   if [[ "$port3" -ne 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHtp=0
   fi     
   port4=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   if [[ -z "$port4" ]]; then
      echo -e "\nport4 = --$port4-- EG : --$eg--"
   fi
   if [[ "$port4" -eq 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHtp=1
   fi   
   if [[ "$port4" -ne 0 ]]; then
      #echo -e "\nValue is Zero"
      flagHtp=0
   fi     
   #if [[ "$port3" -eq 0 && "$port4" -eq 0 ]]; then
   #   flagHtp=0
   #fi   
   echo -e "Eg:$eg-HTTPS:$port1-HTTPSexpl:$port2-HTTP:$port3-HTTPexpl:$port4" >> $LOG

   if [[ "$flagHttps" -eq 1 ]]; then
      echo -e "mqsichangeproperties $brk -e $eg -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
   fi   

   if [[ "$flagHtp" -eq 1 ]]; then
      echo -e "mqsichangeproperties $brk -e $eg -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
   fi   

   ((ENO=ENO+1))
done


