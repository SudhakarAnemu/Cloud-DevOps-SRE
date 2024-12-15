#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh
brk=$1
fno=$2
tag=$3
LOG=HttpHttpsPorts.$brk.$tag.$fno
>$LOG
ENO=1
bport1=`mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
bport2=`mqsireportproperties $brk -b httplistener -o HTTPConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
echo -e "Broker:$brk-https:$bport1-http:$bport2" >> $LOG
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do      
   port1=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n port|grep -v BIP8071I|tr -d '\n'`
   port2=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   port3=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n port|grep -v BIP8071I|tr -d '\n'`
   port4=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   echo -e "Eg:$eg-HTTPS:$port1-HTTPSexpl:$port2-HTTP:$port3-HTTPexpl:$port4" >> $LOG
   ((ENO=ENO+1))
done 

echo -e "\n-----------------------------------------------------------netstat of http ports"
cat $LOG | awk -F"-" '{print $4}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTP port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\n-----------------------------------------------------------netstat of https ports"
cat $LOG | awk -F"-" '{print $2}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTPS port : ***$line***"
   netstat -an | grep $line
done < /tmp/del


echo -e "\n -------------------------------------------------------------------------------------------$tag  Http and Https ports"
cat $LOG
echo -e "----------Syntax to change ports : "
echo -e "mqsichangeproperties brk -e eg -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
echo -e "mqsichangeproperties brk -e eg -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
echo -e "----------List of EGs ---------"
>/tmp/del
cat $LOG | awk -F":" '{print $2}' | awk -F"-" '{print $1}' > /tmp/del
while IFS= read -r line
do
   echo -e "mqsichangeproperties $brk -e $line -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
   echo -e "mqsichangeproperties $brk -e $line -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
done < /tmp/del


   #brk=
   #eg=
   #port1=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n port|grep -v BIP8071I|tr -d '\n'`
   #port2=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   #port3=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n port|grep -v BIP8071I|tr -d '\n'`
   #port4=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
   #echo -e "Eg:$eg-HTTPS:$port1-HTTPSexpl:$port2-HTTP:$port3-HTTPexpl:$port4" >> $LOG