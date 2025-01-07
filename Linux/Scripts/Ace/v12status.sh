#js
# 
# Developer : "Sudhakar Anemu" <sanemu_consultant@cusa.canon.com>

#v12status.sh <broker> Tag 
#/WebSphere/scripts/middleware/ace/v12status.sh brk tag
#!/bin/bash

brk=$1
tag=$2

echo -e "\nS.No - 1 : $brk : $tag- Status of the Broker(Port) - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
mqsilist | grep $brk
echo -e "\nS.No - 2 : $brk : $tag- mqsicvp(success) - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
mqsicvp $brk | grep 'Verification passed for User Datasource'
echo -e "\nS.No - 3 : $brk : $tag- SSL(Key, Trust stores) - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
echo -e "\nTrust and Keystore at Broker level"
mqsireportproperties $brk -o BrokerRegistry -r | grep -E "brokerTruststoreFile|brokerKeystoreFile"

LOG=jksJvmHttps.$brk.$tag.3
>$LOG
/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 3 $tag > $LOG

cat $LOG | grep -v 'Not-Exists'
echo -e "\nS.No - 4 : $brk : $tag- HTTPports - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
LOG=HttpHttpsPorts.$brk.$tag.4
>$LOG
/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh $brk 4 $tag > $LOG
echo -e "\nHTTP and HTTPs ports $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
cat $LOG
echo -e "\nVerifying the netstat of HTTPPort"
cat $LOG | awk -F"-" '{print $4}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTP port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\nVerifying the netstat of HTTPSPort"
cat $LOG | awk -F"-" '{print $2}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTPS port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\nS.No - 5 : List of Stopped flows - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
mqsilist $brk -r| grep -i stop
echo -e "\nCount of Stopped flows - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
mqsilist $brk -r| grep -i stop | wc -l

echo -e "\nS.No - 6 : $brk : $tag-maxThreads of Egs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------"
LOG=maxThreads.$brk.$tag.6
>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "HTTPConnector - maxThreads/MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i MaxConnections  >> $LOG
   echo -e "HTTPSConnector - maxThreads/MaxConnections - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i MaxConnections  >> $LOG
   ((ENO=ENO+1))
done  
cat $LOG | grep maxThreads | grep -v HTTP
echo -e "\nS.No - 7 : $brk : $tag-maxHttpHeaderSize - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------"
LOG=maxHttpHeaderSize.$brk.$tag.7
>$LOG
echo -e "\nS.No - 7 : $brk : $tag-maxHttpHeaderSize - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do    
   echo -e "HTTPConnector - maxHttpHeaderSize - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   echo -e "HTTPSConnector - maxHttpHeaderSize - $brk - $eg($ENO)"  >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\nS.No - 7 : $brk : $tag-maxHttpHeaderSize of EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
cat $LOG | grep maxHttpHeaderSize | grep -v "=''" | grep -v HTTP -B1
echo -e "\nS.No - 7 : $brk : $tag-maxHttpHeaderSize of All EGs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------"
cat $LOG | grep "maxHttpHeaderSize=''"

echo -e "\nS.No - 8 : $brk : $tag-tls of all EGs - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
LOG=tlsssl.$brk.$tag.8
>$LOG
echo -e "\nS.No - 8 : $brk : $tag-Broker $brk - ssl - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i ssl >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i ssl
echo -e "\nS.No - 8 : $brk : $tag-Broker $brk - tls - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------"
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i tls >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i tls
ENO=1
echo -e "\nS.No - 8 : $brk : $tag-Collecting data of tls, ssl for EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "Prop of tls $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i tls >> $LOG
   echo -e "Prop of ssl $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i ssl >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\nS.No - 8 : $brk : $tag-Content of tlsssl file - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
cat $LOG | grep TLS -B1
#echo -e "\nS.No - 8 : $brk : $tag-tls ssl of - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------------"
#cat $LOG | grep TLS -B1
echo -e "\nS.No - 8 : $brk : $tag-Total EGs to execute (#/2 pls) $brk - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
cat $LOG | grep "sslProtocol='TLSv1.2'" | wc -l
echo -e "\n--- EGs where we need to execute tls commands"
cat $LOG | grep "sslProtocol='TLSv1.2'" -B 1 | grep "Prop of tls" | awk -F " " '{print $6}'

echo -e "\nS.No - 9 : $brk : $tag-tls of all EGs - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
mqsireportproperties $brk -b pubsub -o MQTTServer -r

echo "---------------------------- Completed ----------------------------"