#js 
#JS 
#v10Prechecks.sh <broker> Tag 
#/WebSphere/scripts/middleware/v10Prechecks.sh brk tag
#js
#!/bin/bash
LOG=/tmp/log.log
brk=$1
tag=$2
echo -e "\n-------------------------------------- Name of the Broker : $brk "
mqsilist | grep $brk
ps -ef | grep $brk
echo -e "\n-------------------------------------- File 1 : Capturing mqsireportbroker"
mqsireportbroker $brk > mqsireportbroker.$brk.$tag.1
echo -e "\n-------------------------------------- File 2 : Capturing mqsiservice"
mqsiservice $brk > mqsiservice.$brk.$tag.2
echo -e "\n-------------------------------------- File 3 : Capturing mqsicvp"
mqsicvp $brk > mqsicvp.$brk.$tag.3
echo -e "\n Verification passed for User Datasource"
cat mqsicvp.$brk.$tag.3 | grep 'Verification passed for User Datasource'
echo -e "\n One or more problems have been detected with User Datasource"
cat mqsicvp.$brk.$tag.3 | grep 'One or more problems have been detected with User Datasource'

cat mqsicvp.$brk.$tag.3 | grep 'Verification passed for User Datasource' | awk -F"'" '{print $2}' > /tmp/dsn
SNO=1
while IFS= read -r line
do
   echo -e "\n Brk : $brk - DSN : $line - SNO : $SNO"
   #mqsicvp $brk -n $line | grep datasourceServerName
   mqsicvp $brk -n $line | wc -l
   cat -n /var/mqsi/odbc/.v12_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn



echo -e "\n-------------------------------------- File 4 : Capturing Broker propertes"
mqsireportproperties $brk -c AllTypes -o AllReportableEntityNames -r > Config.$brk.$tag.4
echo -e "\n-------------------------------------- File 5 : Capturing Broker dbparms"
mqsireportdbparms $brk -n \* > mqsireportdbparms.$brk.$tag.5
echo -e "\n-------------------------------------- File 6 : Capturing d2 -r of the Broker"
mqsilist $brk -d2 -r > $brk.d2.$tag.6
echo -e "\n-------------------------------------- File 7 : Capturing jks of the Broker and EG"
LOG=jks.$brk.$tag.7
>$LOG
echo -e "\n-------------------------------------- File 7 : Capturing jks of the Broker and EGs" >> $LOG
mqsireportproperties  $brk -o BrokerRegistry -r | grep storeFile >> $LOG
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
SNO=1
while IFS= read -r line
do
    echo "Broker : $brk -- EG : $line --- SNO : $SNO" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -r | grep -i storeFile >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list
SNO=1
echo -e "\n --------- JKS of the broker : $brk"
cat jks.$brk.$tag.7
echo -e "\n --------- Truststore of Egs : $brk"
/WebSphere/scripts/middleware/jksexists.sh $brk | grep -i trusts | grep -v Not



echo -e "\n-------------------------------------- File 8 : Capturing http and https of all EG's"
LOG=httpandhttpsports.$brk.$tag.8
>$LOG
echo -e "\n-------------------------------------- Capturing http and https of all EG's - Brk $brk" >> $LOG
echo -e "\nBroker HTTPS port : " >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i port >> $LOG
echo -e "\nBroker HTTP port : " >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPConnector -r | grep -i port >> $LOG
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
SNO=1
while IFS= read -r line
do
        port=`mqsireportproperties $brk -e  $line  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
        echo  "$SNO:HTTPS--$brk--$line--$port" >> $LOG
        port=`mqsireportproperties $brk -e  $line  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
        echo  "$SNO:HTTP--$brk--$line--$port" >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list
SNO=1

echo -e "\n-------------------------------------- File 8.1 : http and https ports"
LOG=PortsHttpAndHttps.$brk.$tag.8.1
>$LOG
ENO=1
bport1=`mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
bport2=`mqsireportproperties $brk -b httplistener -o HTTPConnector -r | grep -i port | awk -F"'" '{print $2}' | tr -d '\n'`
echo "Broker:$brk-https:$bport1-http:$bport2" >> $LOG
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "Ports of  $brk - $eg($ENO)" >> $LOG
      port1=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n port|grep -v BIP8071I|tr -d '\n'`
      port2=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
      port3=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n port|grep -v BIP8071I|tr -d '\n'`
      port4=`mqsireportproperties $brk -e  $eg  -o HTTPConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
      echo "HTTPS:$port1-HTTPSexpl:$port2-HTTP:$port3-HTTPexpl:$port4-$brk-$eg" >> $LOG

      ((ENO=ENO+1))
   done 

echo -e "\n --------- Http and Https ports of the brokers & EG -- First form : $brk"
cat httpandhttpsports.$brk.$tag.8
echo -e "\n --------- Http and Https ports of the brokers & EG -- Second fortm : $brk"
cat PortsHttpAndHttps.$brk.$tag.8.1

echo -e "\n-------------------------------------- File 9 : Capturing jvmSystemProperty,jvmDebugPort of all EG's"
LOG=jvmProp.$brk.$tag.9
>$LOG
echo -e "\n-------------------------------------- Capturing jvmSystemProperty,jvmDebugPort of all EG's - Brk $brk" >> $LOG
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
while IFS= read -r line
do
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmSystemProperty" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -a | grep -i jvmSystemProperty >> $LOG
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmDebugPort" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -n jvmDebugPort | grep -v BIP8071I >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list

echo -e "\n-------------------------------------- File 10 : Status of EGs"
LOG=EGStatus.$brk.$tag.10
>$LOG
echo -e "\n-------------------------------------- Running EGs - Brk $brk" >> $LOG
mqsilist $brk | grep running | sort -n  >> $LOG
echo -e "\n-------------------------------------- Stopped EGs - Brk $brk" >> $LOG
mqsilist $brk | grep stopped | sort -n  >> $LOG

echo -e "\n --------- Status of EGs : $brk"
cat EGStatus.$brk.$tag.10

echo -e "\n-------------------------------------- File 11 : Status of all Flows"
LOG=AllFlowStatus.$brk.$tag.11
>$LOG
echo -e "\n-------------------------------------- Running EGs - Brk $brk" >> $LOG

   for eg in `mqsilist $brk | sort -n  | grep BIP1286I | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      for msgflw in `mqsilist $brk -e $eg | grep BIP1288I | sort -n | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
         echo "$brk,$eg,$msgflw" >> $LOG
      done 
      for app in `mqsilist $brk -e $eg | grep BIP1275I | awk -F" " '{print $3}' | awk -F"'" '{print $2}'`; do
         for appmsgflow in `mqsilist $brk -e $eg -k $app | grep BIP1277I | sort -n | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
            echo "$brk,$eg,$app,$appmsgflow" >> $LOG
         done
      done 
   done 

echo -e "\n-------------------------------------- File 11 : Status of all Flows - Second set"

LOG=AllFlowStatus.$brk.$tag.11.1
>$LOG
echo -e "\n-------------------------------------- Running EGs - Brk $brk" >> $LOG

   for eg in `mqsilist $brk | sort -n  | grep BIP1286I | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "\n---------------- apps on eg : "  >> $LOG
      mqsilist $brk -e  $eg >> $LOG
      echo -e "\n---------------- apps on eg with -r: "  >> $LOG
      mqsilist $brk -e  $eg -r >> $LOG
      echo "---------------" >> $LOG
   done 

echo -e "\n --------- Count of stopped - EGs, flows  (Stopped) : $brk "
cat -n AllFlowStatus.$brk.$tag.11.1 | grep -i stop | wc -l

echo -e "\n-------------------------------------- File 12 : maxThreads of Egs"
LOG=maxThreads.$brk.$tag.12
>$LOG
echo -e "\n-------------------------------------- maxThreads of EGs - Brk $brk" >> $LOG
   ENO=1
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "HTTPConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxThreads  >> $LOG
      echo -e "HTTPSConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxThreads  >> $LOG
      ((ENO=ENO+1))
   done 
 
echo -e "\n --------- maxThreads of : $brk "
cat maxThreads.$brk.$tag.12 | grep maxThreads | grep -v HTTP

echo -e "\n-------------------------------------- File 13 : maxHttpHeaderSize of Egs"
LOG=maxHttpHeaderSize.$brk.$tag.13
>$LOG
   ENO=1
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do    
      echo -e "HTTPConnector - maxHttpHeaderSize - $brk - $eg($ENO)" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxHttpHeaderSize  >> $LOG
      echo -e "HTTPSConnector - maxHttpHeaderSize - $brk - $eg($ENO)"  >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxHttpHeaderSize  >> $LOG
      ((ENO=ENO+1))
   done 

echo -e "\n --------- maxHttpHeaderSize of : $brk "
cat maxHttpHeaderSize.$brk.$tag.13 | grep maxHttpHeaderSize | grep -v "=''" | grep -v HTTP -B1


echo -e "\n-------------------------------------- File 14 : tls of Egs"
LOG=tlsssl.$brk.$tag.14
>$LOG
echo -e "Broker Prop of tls $brk " >> $LOG

mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i ssl >> $LOG

ENO=1
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "Prop of tls $brk - $eg($ENO)" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i tls >> $LOG
      echo -e "Prop of ssl $brk - $eg($ENO)" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i ssl >> $LOG
      ((ENO=ENO+1))
   done 

echo -e "\n --------- tls ssl of : $brk "
cat tlsssl.$brk.$tag.14 | grep TLS -B1

echo -e "\n-------------------------------------- File 15 : webconsole permissions"
LOG=webconsole.$brk.$tag.15
>$LOG
mqsiwebuseradmin $brk -l >> $LOG

echo -e "\n --------- mqsiwebuseradmin : $brk "
cat webconsole.$brk.$tag.15

echo -e "\n-------------------------------------- File 15.1 : Line number of brokerstart.sh"
cat -n /WebSphere/scripts/middleware/brokerstart.sh | grep $brk

echo -e "\n-------------------------------------- File 16 : All SSL Properties"
LOG=AllSSLProperties.$brk.$tag.16
>$LOG
ENO=1
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "Prop of  $brk - $eg($ENO)" >> $LOG
      echo -e "mqsireportproperties brk -e eg -o ComIbmJVMManager -r | grep store"  >> $LOG
      mqsireportproperties $brk -e $eg -o ComIbmJVMManager -r | grep store >> $LOG
      echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i port" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i port >> $LOG
      echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i Port" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i Port  >> $LOG
      echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a | grep -i store" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i store >> $LOG
      echo -e "mqsireportproperties brk -e eg -o HTTPConnector -a | grep -i store" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i store >> $LOG
      echo -e "mqsireportproperties brk -e eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener" >> $LOG
      mqsireportproperties $brk -e $eg -o ExecutionGroup -a | grep httpNodesUseEmbeddedListener >> $LOG
      echo -e "mqsireportproperties brk -e eg -o HTTPSConnector -a  | grep -i ssl" >> $LOG
      mqsireportproperties $brk -e $eg -o HTTPSConnector -a  | grep -i ssl >> $LOG
      ((ENO=ENO+1))
   done 


echo "----> Completed <----"
