#js
# Wanna to add - netstat of http, httpsports
# Developer : "Sudhakar Anemu" <sanemu_consultant@cusa.canon.com>

#BrkPretasks.sh <broker> Tag 
#/WebSphere/scripts/middleware/ace/BrkPretasks.sh brk tag
#!/bin/bash

#
# Mandatory properties which needs to send
#
#
#
#
#
#
#
#
#
#
#
#
#

brk=$1
tag=$2
#pathtrust=/WebSphere/wmbconfig/tst/truststore/wmbtruststore.jks
#pathtrust=/WebSphere/wmbconfig/dev/truststore/wmbtruststore.jks
pathtrust=/WebSphere/wmbconfig/qa/truststore/wmbtruststore.jks

echo -e "IMP Config variables\nBroker : --$brk--\nTag : --$tag--\nTrust store path : --$pathtrust--"

echo "Do you want to proceed? (y/n)"
read -r answer
echo -e "\nGiven answer is $answer"
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "Exiting..... Please cross check above variables."
  exit 1
fi

#
# Below are all activites will be performed by this script
#

echo -e "ACE, MQ9* Migrate commands"
echo -e "mqsiextractcomponents --backup-file zzzip.zip --source-integration-node $brk --target-integration-node $brk > $brk.migration.ace"
echo -e "/WebSphere/scripts/middleware/ace/MigMQ.sh qmgr brk ver"
echo -e "\n------------------------------------------------------------------------------------Command to validate DSNs - uname and pwd"
echo -e "/WebSphere/scripts/middleware/ace/dsnChkMqscvp.sh  Use this script validate uname and pwd"
echo -e "\nS.No - 1 : $brk : $tag-Current directory (Backup Dir)--------------------------------------------------------------------------"
pwd
echo -e "\nS.No - 2 : $brk : $tag-Broker and QMGR ----------------------------------------------------------------------------------------"
mqsilist | grep $brk
dspmq -o all | grep $brk
echo -e "\n---------------------- Stop and Start commands for the broker : $brk"
echo -e "perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop;perl /WebSphere/scripts/middleware/wmbRestart.pl $brk start;"
echo -e "/WebSphere/scripts/middleware/brkrestart.sh $brk"
echo -e "\nS.No - 3 : $brk : $tag Collecting memory - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------------"
echo -e "Status of free at $(date +%Y-%m-%d_%H-%M-%S)"
free -g
echo -e "\nS.No - 4 : $brk : $tag-Collecting sar - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------------------"
echo -e "Status of sar at $(date +%Y-%m-%d_%H-%M-%S)"
sar > sar.$brk.$tag.0
LOG=/tmp/log.log
echo -e "\nS.No - 5 : $brk : $tag-Broker processes - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------------"
ps -ef | grep $brk
echo -e "\nS.No - 6-1 : $brk : $tag-Properties - $(date +%Y-%m-%d_%H-%M-%S)----------------------------------------------------------------------------------------------"
mqsireportbroker $brk > mqsireportbroker.$brk.$tag.1
echo -e "\nS.No - 7-2 : $brk : $tag-mqsiservice - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------------------"
mqsiservice $brk > mqsiservice.$brk.$tag.2
echo -e "\nS.No - 8-3 : $brk : $tag-mqsicvp - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------------------"
LOG=mqsicvp.$brk.$tag.3
>$LOG
mqsicvp $brk > $LOG
echo -e "\nS.No - 9 : $brk : $tag-Verification passed for User Datasource-----------------------------------------------------------------------------------------------"
cat $LOG | grep 'Verification passed for User Datasource'
echo -e "\nS.No - 10 : $brk : $tag-One or more problems have been detected with User Datasource-------------------------------------------------------------------------"
cat $LOG | grep 'One or more problems have been detected with User Datasource'
#echo -e "\nS.No - 11 : $brk : $tag-Verification of dsn at v12 file - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------"
cat $LOG | grep 'Verification passed for User Datasource' | awk -F"'" '{print $2}' > /tmp/dsn
echo -e "\n-------------------------------------------------------------------------------------------------mqscvp of DSNs for $tag (version)"
SNO=1
while IFS= read -r line
do
   echo -e "\n Verification of dsn(mqsicvp) - Brk : $brk - DSN : $line - SNO : $SNO ------------------------------$tag ---------------------- "
   mqsicvp $brk -n $line | wc -l
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\n-----------------------------------------------------------------------------------------------Line number of DSNs at v10 odbc file"
SNO=1
while IFS= read -r line
do
   echo -e "\n Line number of the dsn(.v10_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO ---------------------$tag -------------------- "
   cat -n /var/mqsi/odbc/.v10_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\n-----------------------------------------------------------------------------------------------Line number of DSNs at v12 odbc file"
SNO=1
while IFS= read -r line
do
   echo -e "\n Line number of the dsn(.v12_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO ---------------------$tag --------------------- "
   cat -n /var/mqsi/odbc/.v12_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\n------------------------------------------------------------------------------------All mqsicvp commands to verify at next version"
SNO=1
while IFS= read -r line
do
   echo "mqsicvp $brk -n $line | wc -l"
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\nS.No - 12-5 : $brk : $tag-mqsireportdbparms - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------"
LOG=mqsireportdbparms.$brk.$tag.5
>$LOG
mqsireportdbparms $brk -n \* > $LOG
echo -e "\nS.No - 13 : $brk : $tag-Full OP of mqsireportdbparms - $(date +%Y-%m-%d_%H-%M-%S)--------------------- ------------------------------------------------------"
cat $LOG
echo -e "\nS.No - 14 : $brk : $tag-mqsireportdbparms for all DSN - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------"
cat $LOG | grep -v '::' | awk -F" " '{print $5":"$8}' | awk -F"'" '{print $2":"$4}'
echo -e "\nS.No - 15-4 : $brk : $tag-AllReportableEntityNames of the $brk - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
LOG=AllReportableEntityNames.$brk.$tag.4
mqsireportproperties $brk -c AllTypes -o AllReportableEntityNames -r > $LOG
mqsireportproperties $brk -o BrokerRegistry -r > $LOG.1
mqsireportproperties $brk -o SecurityCache -r > $LOG.2
echo -e "\nS.No - 16 : $brk : $tag-d2 (Of entire $brk) - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
#mqsilist $brk -d2 -r > $brk.d2.$tag.6

ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "\n-----Capturing d2 for $eg, SNO : $ENO"
   mqsilist $brk -e $eg -d2 -r > $ENO.mqsilist.$brk.$eg.d2
   ((ENO=ENO+1))
done  


echo -e "\nS.No - 17 : $brk : $tag-jksHttpsJvm - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------------------"
LOG=jksJvmHttps.$brk.$tag.7
>$LOG
/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 7 $tag > $LOG
echo -e "\nS.No - 18 : $brk : $tag-Truststore of Egs - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------"
echo -e "\n----------------------------------------------------------------------------------------------- All trusts"
cat $LOG | grep -i trusts | grep -v Not
echo -e "\n-------------------- All Unique Trusts"
cat $LOG | grep -i trusts | grep -v Not | awk -F ":" '{print $5}' | uniq | sort -n
echo -e "\nChk exits : /WebSphere/scripts/middleware/CompareTwoJKS.sh $pathtrust wmbtruststore RequirdJKS pwd | grep 'not exist'"
echo -e "\nS.No - 19 : $brk : $tag-Trustsore commands to be execute - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------"
>/tmp/del
cat $LOG | grep -i trusts | grep -v Not | awk -F":" '{print $3}' > /tmp/del

while IFS= read -r eg
do
   echo -e "mqsichangeproperties $brk -e $eg  -o ComIbmJVMManager -n truststoreType,truststoreFile,truststorePass -v JKS,$pathtrust,$eg::truststorePass"
   echo -e "mqsisetdbparms $brk -n $eg::truststorePass -u ignore -p wmbtruststore"
done < /tmp/del
echo -e "\nS.No - 20 : $brk : $tag-Keystores of Egs - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------------"
echo -e "\nS.No - 21 : $brk : $tag-Keystores of the EG - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
echo -e "\nS.No - 22 : $brk : $tag - Keystores of the EG - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------"
cat $LOG | grep -i Keystore | grep -v Not | grep -v Truststore
echo -e "\nS.No - 23 : $brk : $tag-Unique-keystores - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------------------"
cat $LOG | grep -i Keystore | grep -v Not | grep -v Truststore | awk -F":" '{print $5}' | uniq | sort -n
echo -e "\nS.No - 24 : $brk : $tag-v9/v10 to ace - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------------"
cat $LOG | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g'
echo -e "\nS.No - 24 : $brk : $tag-ls -l of v9/v10 to ace - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------"
cat $LOG | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g' > /tmp/del
SNO=1
while IFS= read -r line
do
   echo -e "\n----- S.No : $SNO"
   ls -l $line
   ((SNO=SNO+1))
done < /tmp/del
echo -e "\nS.No - 25 : $brk : $tag-Commands of Kestore to execute - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------"
cat $LOG | grep -i ":Keystore" | grep -v Not | awk -F ":" '{print "mqsichangeproperties BROKER -e " $3 " -o ComIbmJVMManager -n keystoreFile -v " $5}'
echo -e "\nS.No - 26 : $brk : $tag-Key and Trust stores of Egs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------"
cat $LOG
echo -e "\nS.No - 27 : $brk : $tag-Key and Trust stores of Egs(Only Exists) - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------"
cat $LOG | grep -v 'Not-Exists'
echo -e "\nS.No - 27.1 : $brk : $tag-Key and Trust stores of Egs(Only NotExists) - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------"
cat $LOG | grep 'Not-Exists'
echo -e "\nS.No - 28-8 : $brk : $tag-http and https - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------"
#LOG=HttpHttpsPorts.$brk.$tag.8.1
#>$LOG
#echo -e "\nActual commands needs to execute"
#/WebSphere/scripts/middleware/ace/New1_HttpHttpsPorts.sh $brk 8.1 $tag > $LOG
#echo -e "\nActual commands needs to execute"
#echo -e "\n"
#LOG=HttpHttpsPorts.$brk.$tag.8
>$LOG
/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh $brk 8 $tag > $LOG
echo -e "\nS.No - 29.0 : Http and Http ports"
cat $LOG
echo -e "\nS.No - 29 : $brk : $tag-netstat of http ports - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------"
cat $LOG | awk -F"-" '{print $4}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTP port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\nS.No - 30 : $brk : $tag-netstat of https ports - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------"
cat $LOG | awk -F"-" '{print $2}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTPS port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\nS.No - 31 : $brk : $tag-Http and Https ports - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
cat $LOG
echo -e "----------Syntax to change ports : "
echo -e "mqsichangeproperties brk -e eg -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
echo -e "mqsichangeproperties brk -e eg -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
echo -e "----------Syntax to change prop of EGs ---------"
>/tmp/del
#cat $LOG | awk -F":" '{print $2}' | awk -F"-" '{print $1}' > /tmp/del
#while IFS= read -r line
#do
#   echo -e "mqsichangeproperties $brk -e $line -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
#   echo -e "mqsichangeproperties $brk -e $line -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
#done < /tmp/del

mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}' > /tmp/del

while IFS= read -r line
do
   echo -e "mqsichangeproperties $brk -e $line -o HTTPSConnector -n port,explicitlySetPortNumber -v 0,0"
   echo -e "mqsichangeproperties $brk -e $line -o HTTPConnector -n port,explicitlySetPortNumber -v 0,0"
done < /tmp/del
 
echo -e "\nS.No - 31 : $brk : $tag-jvmSystemProperty,jvmDebugPort of all EG's - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------"
LOG=jvmSystemPropertyJvmDPort.$brk.$tag.9
>$LOG
echo -e "\nS.No - 33 : $brk : $tag-Capturing jvmSystemProperty,jvmDebugPort of all EG's - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------------------"
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
while IFS= read -r line
do
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmSystemProperty" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -a | grep -i jvmSystemProperty >> $LOG
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmDebugPort" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -n jvmDebugPort | grep -v BIP8071I >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list
echo -e "\nS.No - 34-10 : $brk : $tag-Stopped EGs - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------------"
LOG=EGStatus.$brk.$tag.10
>$LOG
echo -e "\nS.No - 35 : $brk : $tag-Capturing Status of EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
mqsilist $brk | sort -n >> $LOG
echo -e "\nS.No - 36 : $brk : $tag-Running EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------------"
cat $LOG | grep -i runn
echo -e "\nS.No - 37 : $brk : $tag-Stopped EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------------"
cat $LOG | grep -i stop
echo -e "\nS.No - 38 : $brk : $tag-Status of Flows - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------"
LOG=AllFlowStatus.$brk.$tag.11
>$LOG
mqsilist $brk -r > $LOG
echo -e "\nS.No - 39 : $brk : $tag-Count of stopped - WMB Components  (Stopped) - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------"
cat $LOG | grep -i stopped | wc -l
echo -e "\nS.No - 40 : $brk : $tag-List of Stopped components - EGs, flows (Stopped) - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------"
cat $LOG | grep -i stopped
echo -e "\nS.No - 40.1 : $brk : $tag-List of Stopped components(only msg flows) - EGs, flows (Stopped) - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------"
cat $LOG | grep -i stopped | grep "Message flow"

echo -e "\nS.No - 40.2 : $brk : $tag-List of Stopped components(only msg Applications) - EGs, flows (Stopped) - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------"
cat $LOG | grep -i stopped | grep BIP1276I

echo -e "\nS.No - 40.3 : $brk : $tag-List of Stopped components(only File) - EGs, flows (Stopped) - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------"
cat $LOG | grep -i stopped | grep File

echo -e "\nS.No - 41 : $brk : $tag-mqsistop commands(EGs) for V12 - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------"
mqsilist $brk | grep -i stopped | awk -F "'" '{print "mqsistop BRK -e "$2}'
echo -e "\nS.No - 43 : $brk : $tag-BIP1278I - mqsistop commands(flows) for v12 - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------"
cat $LOG| grep -i stopped | grep BIP1278I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k " $6 " -m "$2}'
echo -e "\nS.No - 44 : $brk : $tag-BIP1289I(no App) - mqsistop commands(flows) for V12 - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------"
cat $LOG| grep -i stopped | grep BIP1289I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k  App" " -m "$2}'
echo -e "\nS.No - 45 : $brk : $tag-mqsistop commands(Applications) for V12 - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------"
cat $LOG| grep -i stopped | grep BIP1276I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k " $2}'
echo -e "\nS.No - 46-12 : $brk : $tag-maxThreads of Egs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------------"
LOG=maxThreads.$brk.$tag.12
>$LOG
echo -e "\nS.No -47 : $brk : $tag-maxThreads of EGs - Brk $brk - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------"
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "HTTPConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxThreads  >> $LOG
   echo -e "HTTPSConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxThreads  >> $LOG
   ((ENO=ENO+1))
done  
cat $LOG | grep maxThreads | grep -v HTTP
echo -e "\nS.No - 48-13 : $brk : $tag-maxHttpHeaderSize - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------------"
LOG=maxHttpHeaderSize.$brk.$tag.13
>$LOG
echo -e "\nS.No - 49 : $brk : $tag-maxHttpHeaderSize - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do    
   echo -e "HTTPConnector - maxHttpHeaderSize - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   echo -e "HTTPSConnector - maxHttpHeaderSize - $brk - $eg($ENO)"  >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\nS.No - 50 : $brk : $tag-maxHttpHeaderSize of EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
cat maxHttpHeaderSize.$brk.$tag.13 | grep maxHttpHeaderSize | grep -v "=''" | grep -v HTTP -B1
echo -e "\nS.No - 51 : $brk : $tag-maxHttpHeaderSize of All EGs - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------"
cat maxHttpHeaderSize.$brk.$tag.13 | grep "maxHttpHeaderSize=''"
echo -e "\nS.No - 52-14 : $brk : $tag-tls of all EGs - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------------"
LOG=tlsssl.$brk.$tag.14
>$LOG
echo -e "\nS.No - 53 : $brk : $tag-Broker Prop of tls $brk - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
echo -e "\nS.No - 54 : $brk : $tag-Broker $brk - ssl - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i ssl >> $LOG
echo -e "\nS.No - 55 : $brk : $tag-mqsicBroker $brk - tls - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------"
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i tls >> $LOG
ENO=1
echo -e "\nS.No - 56 : $brk : $tag-Collecting datat of tls, ssl for EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "Prop of tls $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i tls >> $LOG
   echo -e "Prop of ssl $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i ssl >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\nS.No - 57 : $brk : $tag-Content of tlsssl file - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------"
cat $LOG | grep TLS -B1
echo -e "\nS.No - 58 : $brk : $tag-tls ssl of - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------------"
cat $LOG | grep TLS -B1
echo -e "\nS.No - 59 : $brk : $tag-Total EGs to execute (#/2 pls) $brk - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
cat $LOG | grep "sslProtocol='TLSv1.2'" | wc -l
echo -e "\n--- EGs where we need to execute tls commands with commands"
#cat $LOG | grep "sslProtocol='TLSv1.2'" -B 1 | grep "Prop of tls" | awk -F " " '{print $6}'
cat $LOG | grep "sslProtocol='TLSv1.2'" -B 1 | grep "Prop of tls $brk" | awk -F" " '{print $6}' | awk -F"(" '{print $1}' > /tmp/del
echo -e "\n---------------------------------------- List of EGs which has TLSv1.2"
cat /tmp/del
echo -e "\n---------------------------------------- List of Commands which needs to be executed"
while IFS= read -r line
do
   echo -e "mqsichangeproperties $brk -e $line -o HTTPSConnector -n TLSProtocols -v 'TLSv1.2'"
done < /tmp/del
echo -e "List of all commands for all EGs : "
>/tmp/del
cat $LOG | grep 'Prop of ssl' | awk -F "-" '{print $2}' | awk -F "(" '{print $1}' > /tmp/del
echo -e "--- Broker tls command"
echo -e "mqsichangeproperties $brk -b httplistener -o HTTPSConnector -n TLSProtocols -v 'TLSv1.2'"
echo -e "--- EG's tls commands"
while IFS= read -r line
do
   echo -e "mqsichangeproperties $brk -e $line -o HTTPSConnector -n TLSProtocols -v 'TLSv1.2'"
done < /tmp/del
echo -e "\nS.No - 61--15 : $brk : $tag-webconsole & $brk port - $(date +%Y-%m-%d_%H-%M-%S)-----------------------------------------------------------------------------"
mqsilist | grep $brk
LOG=webconsole.$brk.$tag.15
>$LOG
mqsiwebuseradmin $brk -l >> $LOG
echo -e "\n ---------------------------------------------------------- mqsiwebuseradmin : $brk "
cat $LOG
echo -e "\nS.No - 62 : $brk : $tag-Line number of brokerstart.sh - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------------"
cat -n /WebSphere/scripts/middleware/brokerstart.sh | grep $brk
echo -e "/WebSphere/scripts/middleware/brokerstart.sh -> This script needs to be update"
echo -e "\nS.No - 63-16 : $brk : $tag-Collecting all SSL prop of all EGs - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------"
LOG=AllSSLProperties.$brk.$tag.16
>$LOG
/WebSphere/scripts/middleware/ace/AllSslPropEgs.sh $brk 16 $tag > $LOG
echo -e "\nS.No - 64-18 : $brk : $tag-Collecting all flows with status - $(date +%Y-%m-%d_%H-%M-%S)--------------------------------------------------------------------"
LOG=AllFlowStatus.$brk.$tag.18
>$LOG
#echo -e "\n---------------------------------------------------------------------------------------Collecting all running components"

#   for eg in `mqsilist $brk | sort -n  | grep BIP1286I | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
#      for msgflw in `mqsilist $brk -e $eg | grep BIP1288I | sort -n | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
#         echo "$brk,$eg,$msgflw" >> $LOG
#      done 
#      for app in `mqsilist $brk -e $eg | grep BIP1275I | awk -F" " '{print $3}' | awk -F"'" '{print $2}'`; do
#         for appmsgflow in `mqsilist $brk -e $eg -k $app | grep BIP1277I | sort -n | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
#            echo "$brk,$eg,$app,$appmsgflow" >> $LOG
#         done
#      done 
#   done 
echo -e "\nS.No - 65 : $brk : $tag-MQTT properties and commands - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------------"
mqsireportproperties $brk -b pubsub -o MQTTServer -r
echo "mqsireportproperties $brk -b pubsub -o MQTTServer -r"
echo "mqsichangeproperties $brk -b pubsub -o MQTTServer -n enabled -v false"
echo "mqsichangeproperties $brk -b pubsub -o MQTTServer -n port -v '0'"
echo "mqsireportproperties $brk -b pubsub -o MQTTServer -r"
echo -e "\nS.No - 66 : $brk : $tag-Health of the qmgr - $(date +%Y-%m-%d_%H-%M-%S)------------------------------------------------------------------------------------"
/WebSphere/scripts/middleware/mqhealth.sh | grep $brk
pwd
echo -e "\nS.No - 67-17 : $brk : $tag-Collecting all prop of all EGs - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------"
LOG=AllPropEgs.$brk.$tag.17
>$LOG
/WebSphere/scripts/middleware/ace/AllPropEgs.sh $brk 17 $tag > $LOG

echo -e "\nS.No - 68 : $brk : $tag-List of all Files - $(date +%Y-%m-%d_%H-%M-%S)-------------------------------------------------------------------------------------"
pwd
ls -lrt *

echo -e "\nS.No - 69 : $brk : $tag-Https and Http commands - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------"

echo -e "\nActual http commands needs to execute"
/WebSphere/scripts/middleware/ace/New1_HttpHttpsPorts.sh $brk 8.1 $tag


echo -e "\nS.No - 70 : $brk : $tag-jar file - $(date +%Y-%m-%d_%H-%M-%S)---------------------------------------------------------------------"
echo -e "\n----- Count of jars"
ls -l /var/mqsi/config/$brk/shared-classes/*.jar | wc -l
echo -e "\n----- Path of s21ib_fw_java.jar"
ls -l /var/mqsi/config/$brk/shared-classes/s21ib_fw_java.jar
echo -e "\n----- Path of s21ib_fw_java.jar using find command"
cd /var/mqsi/config/$brk/
find ./ -name s21ib_fw_java.jar


echo -e "\nSuccessfully completed - Bye Bye"
echo "----> Completed <----"
