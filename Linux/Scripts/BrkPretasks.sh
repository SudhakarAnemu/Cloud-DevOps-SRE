#js sudha
# Wanna to add - netstat of http, httpsports
#
#v10Prechecks.sh <broker> Tag 
#/WebSphere/scripts/middleware/ace/BrkPretasks.sh brk tag
#!/bin/bash
brk=$1
tag=$2
echo -e "\n-------------------------------------------------------------------------------------------- 1. Collecting memory - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "Status of free at $(date +%Y-%m-%d_%H-%M-%S)"
free -g
echo -e "\n-------------------------------------------------------------------------------------------- 2. Collecting sar - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "Status of sar at $(date +%Y-%m-%d_%H-%M-%S)"
sar
LOG=/tmp/log.log
echo -e "\n-------------------------------------------------------------------------------------------- 3. $brk processes - $(date +%Y-%m-%d_%H-%M-%S)"
mqsilist | grep $brk
ps -ef | grep $brk
echo -e "\n-------------------------------------------------------------------------------------------- 4-1. $brk properties - $(date +%Y-%m-%d_%H-%M-%S)"
mqsireportbroker $brk > mqsireportbroker.$brk.$tag.1
echo -e "\n-------------------------------------------------------------------------------------------- 5-2. $brk mqsiservice - $(date +%Y-%m-%d_%H-%M-%S)"
mqsiservice $brk > mqsiservice.$brk.$tag.2
echo -e "\n-------------------------------------------------------------------------------------------- 6-3. $brk mqsicvp - $(date +%Y-%m-%d_%H-%M-%S)"
mqsicvp $brk > mqsicvp.$brk.$tag.3
echo -e "\n Verification passed for User Datasource -------------------------------------------------"
cat mqsicvp.$brk.$tag.3 | grep 'Verification passed for User Datasource'
echo -e "\n One or more problems have been detected with User Datasource -------------------------------------------------"
cat mqsicvp.$brk.$tag.3 | grep 'One or more problems have been detected with User Datasource'
echo -e "\n-------------------------------------------------------------------------------------------- 7. Verification of dsn at v12 file - $(date +%Y-%m-%d_%H-%M-%S)"
cat mqsicvp.$brk.$tag.3 | grep 'Verification passed for User Datasource' | awk -F"'" '{print $2}' > /tmp/dsn
SNO=1
while IFS= read -r line
do
   echo -e "\n Vrfcton of dsn(mqsicvp) - Brk : $brk - DSN : $line - SNO : $SNO ------------------------------------------------------- "
   mqsicvp $brk -n $line | wc -l
   echo -e "\n Line number of the dsn(.v10_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO ----------------------------------------- "
   cat -n /var/mqsi/odbc/.v10_odbc.ini | grep $line
   echo -e "\n Line number of the dsn(.v12_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO ----------------------------------------- "
   cat -n /var/mqsi/odbc/.v12_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\n-------------------------------------------------------------------------------------------- 8-5. mqsireportdbparms - $(date +%Y-%m-%d_%H-%M-%S)"
mqsireportdbparms $brk -n \* > mqsireportdbparms.$brk.$tag.5
mqsireportdbparms $brk -n \* | grep -v '::'
echo -e "\n-------------------------------------------------------------------------------------------- 9-4. AllReportableEntityNames - $(date +%Y-%m-%d_%H-%M-%S)"
mqsireportproperties $brk -c AllTypes -o AllReportableEntityNames -r > AllReportableEntityNames.$brk.$tag.4
echo -e "\n-------------------------------------------------------------------------------------------- 10-6. d2 (Of entire $brk) - $(date +%Y-%m-%d_%H-%M-%S)"
mqsilist $brk -d2 -r > $brk.d2.$tag.6
echo -e "\n-------------------------------------------------------------------------------------------- 11-7. jksHttpsJvm - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=jksJvmHttps.$brk.$tag.7
>$LOG
/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 7 $tag > $LOG
echo -e "\n ------------------------------------------------------------------------------------------- Truststore of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG | grep -i trusts | grep -v Not
echo -e "\n ------------------------------------------------------------------------------------------- Keystores of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG | grep -i Keystore | grep -v Not
echo -e "\n ------------------------------------------------------------------------------------------- Key and Trust stores of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG
echo -e "\n-------------------------------------------------------------------------------------------- 12-8. http and https - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=HttpHttpsPorts.$brk.$tag.8
>$LOG
/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh $brk 8 $tag > $LOG
echo -e "\n ------------------------------------------------------------------------------------------- Http and Https ports"
cat $LOG
echo -e "\n-------------------------------------------------------------------------------------------- 13-9. jvmSystemProperty,jvmDebugPort of all EG's - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=jvmSystemPropertyJvmDPort.$brk.$tag.9
>$LOG
echo -e "\n--------------------------------------------------------------------------- Capturing jvmSystemProperty,jvmDebugPort of all EG's - Brk $brk" >> $LOG
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
while IFS= read -r line
do
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmSystemProperty" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -a | grep -i jvmSystemProperty >> $LOG
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmDebugPort" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -n jvmDebugPort | grep -v BIP8071I >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list
echo -e "\n-------------------------------------------------------------------------------------------- 14-10. Stopped EGs - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=EGStatus.$brk.$tag.10
>$LOG
echo -e "\n--------------------------------------------------------------------------- Capturing Status of EGs : " >> $LOG
mqsilist $brk | sort -n >> $LOG
echo -e "\n-------------------------------------------------------------------------------------------- Running EGs - Brk $brk"
cat $LOG | grep -i runn
echo -e "\n-------------------------------------------------------------------------------------------- Stopped EGs - Brk $brk"
cat $LOG | grep -i stop
echo -e "\n-------------------------------------------------------------------------------------------- 15-11 and 11.1. Status of Flows - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=AllFlowStatus.$brk.$tag.11
>$LOG
echo -e "\n-------------------------------------------------------------------------------------------- Flows from Running EGs - Brk $brk" >> $LOG
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
echo -e "\n--------------------------------------------------------------------------------------------- Second set (#2) of Status of all Flows"

LOG=AllFlowStatus.$brk.$tag.11.1
>$LOG
>$LOG.SecondFile
echo -e "\n-------------------------------------- Running EGs - Brk $brk" >> $LOG

   for eg in `mqsilist $brk | sort -n  | grep BIP1286I | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "\n----------------------------------------------------------------- Apps on eg : $eg"  >> $LOG.SecondFile
      mqsilist $brk -e  $eg >> $LOG.SecondFile
      echo -e "\n----------------------------------------------------------------- Apps on eg : $eg  with -r option "  >> $LOG
      mqsilist $brk -e  $eg -r >> $LOG
      echo "---------------" >> $LOG
   done 

echo -e "\n --------------------------------------------------------------  Count of stopped - EGs, flows  (Stopped) : $brk "
cat -n AllFlowStatus.$brk.$tag.11.1 | grep -i stop | wc -l

echo -e "\n --------------------------------------------------------------- List of Stopped components - EGs, flows  (Stopped) : $brk "
cat -n AllFlowStatus.$brk.$tag.11.1 | grep -i stop





echo -e "\nSuccessfully completed - Bye Bye"



>/WebSphere/scripts/middleware/ace/BrkPretasks.sh
 
/WebSphere/scripts/middleware/ace/BrkPretasks.sh IIBDVAA26 v10




 









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

echo -e "\n-------------------------------------- File 17 : jks of Egs"
LOG=jksOfEgs.$brk.$tag.17
>$LOG
ENO=1
   for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "Prop of  $brk - $eg($ENO)" >> $LOG

        echo -e "SNO:$SNO--Broker:$brk--EG:$eg---------------------------------------------------------------" >> $LOG
        echo -e "Store of ComIbmJVMManager"  >> $LOG
        mqsireportproperties $brk -e $eg -o ComIbmJVMManager -r | grep store | grep .jks  >> $LOG
        echo -e "Store of HTTPSConnector"  >> $LOG
        mqsireportproperties $brk -e $eg -o HTTPSConnector -a | grep -i store  | grep .jks  >> $LOG
        echo -e "Store of HTTPConnector"  >> $LOG
        mqsireportproperties $brk -e $eg -o HTTPConnector -a | grep -i store  | grep .jks  >> $LOG

      ((ENO=ENO+1))
   done 

echo "----> Completed <----"
