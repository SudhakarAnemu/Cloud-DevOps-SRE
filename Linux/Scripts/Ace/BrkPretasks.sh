#js
# Wanna to add - netstat of http, httpsports
# Developer : "Sudhakar Anemu" <sanemu_consultant@cusa.canon.com>

#v10Prechecks.sh <broker> Tag 
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
pathtrust=/WebSphere/wmbconfig/tst/truststore/wmbtruststore.jks

#
# Below are all activites will be performed by this script
#

echo -e "ACE, MQ9* Migrate commands"
echo -e "mqsiextractcomponents --backup-file zzzip.zip --source-integration-node $brk --target-integration-node $brk > $brk.migration.ace"
echo -e "/WebSphere/scripts/middleware/ace/MigMQ.sh qmgr brk ver"

echo -e "-------------------------------------------------------------------------- 1. $tag Current directory (Backup Dir) "
pwd
echo -e "-------------------------------------------------------------------------- 2. $tag Broker and QMGR "
mqsilist | grep $brk
dspmq -o all | grep $brk
echo -e "-------------------------- Configuring env variables "


echo -e "\n---------------------- Stop and Start commands for the broker : $brk"
echo -e "perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop;perl /WebSphere/scripts/middleware/wmbRestart.pl $brk start;"
echo -e "/WebSphere/scripts/middleware/brkrestart.sh $brk"
echo -e "\n-------------------------------------------------------------------------------------------- 3. $tag 1. Collecting memory - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "Status of free at $(date +%Y-%m-%d_%H-%M-%S)"
free -g
echo -e "\n-------------------------------------------------------------------------------------------- 4. $tag 2. Collecting sar - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "Status of sar at $(date +%Y-%m-%d_%H-%M-%S)"
sar
LOG=/tmp/log.log
echo -e "\n-------------------------------------------------------------------------------------------- 5. $tag 3. $brk processes - $(date +%Y-%m-%d_%H-%M-%S)"
mqsilist | grep $brk
ps -ef | grep $brk
echo -e "\n-------------------------------------------------------------------------------------------- 6. $tag 4-1. $brk properties - $(date +%Y-%m-%d_%H-%M-%S)"
mqsireportbroker $brk > mqsireportbroker.$brk.$tag.1
echo -e "\n-------------------------------------------------------------------------------------------- 7. $tag 5-2. $brk mqsiservice - $(date +%Y-%m-%d_%H-%M-%S)"
mqsiservice $brk > mqsiservice.$brk.$tag.2
echo -e "\n-------------------------------------------------------------------------------------------- 8. $tag 6-3. $brk mqsicvp - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=mqsicvp.$brk.$tag.3
>$LOG
mqsicvp $brk > $LOG
echo -e "\n Verification passed for User Datasource $tag ---------------------------$brk--------------------9. $tag "
cat $LOG | grep 'Verification passed for User Datasource'
echo -e "\n One or more problems have been detected with User Datasource -------------------------------------------------10. $tag "
cat $LOG | grep 'One or more problems have been detected with User Datasource'
echo -e "\n--------------------------------------------------------------------------------------------11. Verification of dsn at v12 file - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG | grep 'Verification passed for User Datasource' | awk -F"'" '{print $2}' > /tmp/dsn
echo -e "\nmqscvp for $tag - It must be a version. "
SNO=1
while IFS= read -r line
do
   echo -e "\n Verification of dsn(mqsicvp) - Brk : $brk - DSN : $line - SNO : $SNO ---------------------------------$tag ---------------------- "
   mqsicvp $brk -n $line | wc -l
   ((SNO=SNO+1))
done < /tmp/dsn
SNO=1
while IFS= read -r line
do
   echo -e "\n Line number of the dsn(.v10_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO ---------------------$tag -------------------- "
   cat -n /var/mqsi/odbc/.v10_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn
SNO=1
while IFS= read -r line
do
   echo -e "\n Line number of the dsn(.v12_odbc.ini) - Brk : $brk - DSN : $line - SNO : $SNO --------------------$tag --------------------- "
   cat -n /var/mqsi/odbc/.v12_odbc.ini | grep $line
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "\n All mqsicvp commands : "
SNO=1
while IFS= read -r line
do
   echo "mqsicvp $brk -n $line | wc -l"
   ((SNO=SNO+1))
done < /tmp/dsn
echo -e "/WebSphere/scripts/middleware/ace/dsnChkMqscvp.sh  Use this script validate uname and pwd"
echo -e "\n--------------------------------------------------------------------------------------------12. $tag  8-5. mqsireportdbparms - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=mqsireportdbparms.$brk.$tag.5
>$LOG
mqsireportdbparms $brk -n \* > $LOG
echo -e "\n--------------------------------------------------------------------------------------------13. mqsireportdbparms for all"
cat $LOG
echo -e "\n--------------------------------------------------------------------------------------------14. mqsireportdbparms for all DSN"
cat $LOG | grep -v '::' | awk -F" " '{print $5":"$8}' | awk -F"'" '{print $2":"$4}'
echo -e "\n--------------------------------------------------------------------------------------------15. $tag  9-4. AllReportableEntityNames - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=AllReportableEntityNames.$brk.$tag.4
mqsireportproperties $brk -c AllTypes -o AllReportableEntityNames -r > $LOG

mqsireportproperties $brk -o BrokerRegistry -r > $LOG.1
mqsireportproperties $brk -o SecurityCache -r > $LOG.2


echo -e "\n--------------------------------------------------------------------------------------------16. $tag  10-6. d2 (Of entire $brk) - $(date +%Y-%m-%d_%H-%M-%S)"
mqsilist $brk -d2 -r > $brk.d2.$tag.6
echo -e "\n--------------------------------------------------------------------------------------------17. $tag  11-7. jksHttpsJvm - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=jksJvmHttps.$brk.$tag.7
>$LOG
/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 7 $tag > $LOG
echo -e "\n -------------------------------------------------------------------------------------------18. $tag  Truststore of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "\n-------------------- All trusts"
cat $LOG | grep -i trusts | grep -v Not
echo -e "\n-------------------- All Uniq Trusts"
cat $LOG | grep -i trusts | grep -v Not | awk -F ":" '{print $5}' | uniq
echo -e "\nChk exits : /WebSphere/scripts/middleware/CompareTwoJKS.sh /WebSphere/wmbconfig/tst/truststore/wmbtruststore.jks wmbtruststore /WebSphere/wmbconfig/tst1/keystore/v10/esbtst/esbtst.jks esbtst | grep 'not exist'
"

echo -e "\n--------------------------------------------------------------------------------------------19. $tag  Trustsore commands to be execute--"
>/tmp/del
cat $LOG | grep -i trusts | grep -v Not | awk -F":" '{print $3}' > /tmp/del

while IFS= read -r eg
do
   echo -e "mqsichangeproperties $brk -e $eg  -o ComIbmJVMManager -n truststoreType,truststoreFile,truststorePass -v JKS,$pathtrust,$eg::truststorePass"
   echo -e "mqsisetdbparms $brk -n $eg::truststorePass -u ignore -p wmbtruststore"
done < /tmp/del
echo -e "\n ------------------------------------------------------------------------------------------20. $tag  Keystores of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "\n-------------------------------------------------------------------------------------------21. $tag -  Keystores of the EG"
cat $LOG | grep -i Keystore | grep -v Not | grep -v Truststore
echo -e "\n-------------------------------------------------------------------------------------------22. $tag -  Uniq - Keystores of the EG"
cat $LOG | grep -i Keystore | grep -v Not | grep -v Truststore | awk -F":" '{print $5}' | uniq
echo -e "\n-------------------------------------------------------------------------------------------23. $tag -  v9/v10 to ace"
#cat $LOG | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g'
cat $LOG | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g'
echo -e "---------------------------------------------------------------------------------------------24.  ls -l of v9/v10 to ace"
cat $LOG | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g' > /tmp/del
while IFS= read -r line
do
   ls -l $line
done < /tmp/del
echo -e "\n--------------------------------------------------------------------------------------------25. $tag  Commands of Kestore to execute"
cat $LOG | grep -i ":Keystore" | grep -v Not | awk -F ":" '{print "mqsichangeproperties BROKER -e " $3 " -o ComIbmJVMManager -n keystoreFile -v " $5}'

echo -e "\n ---------------------------------------------------------------------------$brk----------------26. $tag  Key and Trust stores of Egs - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG

echo -e "\n --------------------------------------------------------------------------$brk-----------------27. $tag  Key and Trust stores of Egs(Only Exists) - $(date +%Y-%m-%d_%H-%M-%S)"
cat $LOG | grep -v 'Not-Exists'


echo -e "\n--------------------------------------------------------------------------$brk------------------28. $tag  12-8. http and https - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=HttpHttpsPorts.$brk.$tag.8
>$LOG
/WebSphere/scripts/middleware/ace/HttpHttpsPorts.sh $brk 8 $tag > $LOG


echo -e "\n---------------------------------------------------------------------------$brk-----------------29. netstat of http ports"
cat $LOG | awk -F"-" '{print $4}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTP port : ***$line***"
   netstat -an | grep $line
done < /tmp/del
echo -e "\n---------------------------------------------------------------------------$brk----------------30. netstat of https ports"
cat $LOG | awk -F"-" '{print $2}' | grep -v ":0" | cut -d":" -f2 > /tmp/del
while IFS= read -r line
do
   echo -e "Testing the HTTPS port : ***$line***"
   netstat -an | grep $line
done < /tmp/del

echo -e "\n ----------------------------------------------------------------------------$brk---------------31. $tag  Http and Https ports"
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


echo -e "\n-----------------------------------------------------------------------------$brk----------------- 32. $tag  13-9. jvmSystemProperty,jvmDebugPort of all EG's - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=jvmSystemPropertyJvmDPort.$brk.$tag.9
>$LOG
echo -e "\n-----------------------------------------------------------------------------$brk------------------33.  Capturing jvmSystemProperty,jvmDebugPort of all EG's - Brk $brk" >> $LOG
mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n> /tmp/eg.list
while IFS= read -r line
do
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmSystemProperty" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -a | grep -i jvmSystemProperty >> $LOG
    echo "$SNO:Broker : $brk -- EG : $line --- SNO : $SNO -- jvmDebugPort" >> $LOG
    mqsireportproperties $brk -e $line -o ComIbmJVMManager -n jvmDebugPort | grep -v BIP8071I >> $LOG
    ((SNO=SNO+1))
done < /tmp/eg.list
echo -e "\n-----------------------------------------------------------------------------$brk------------------34. $tag  14-10. Stopped EGs - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=EGStatus.$brk.$tag.10
>$LOG
echo -e "\n----------------------------------------------------------------------------$brk-------------------35.  Capturing Status of EGs : " >> $LOG
mqsilist $brk | sort -n >> $LOG
echo -e "\n------------------------------------------------------------------------------$brk-----------------36. $tag  Running EGs - Brk $brk"
cat $LOG | grep -i runn
echo -e "\n-----------------------------------------------------------------------------$brk------------------37. $tag  Stopped EGs - Brk $brk"
cat $LOG | grep -i stop

echo -e "\n-----------------------------------------------------------------------------$brk------------------38. $tag  15-11 Status of Flows - $(date +%Y-%m-%d_%H-%M-%S)"
LOG=AllFlowStatus.$brk.$tag.11
>$LOG
mqsilist $brk -r > $LOG

echo -e "\n ------------------------------------------------------------------------------$brk-------------------------39.  Count of stopped - WMB Components  (Stopped) : $brk "
cat $LOG | grep -i stop | wc -l

echo -e "\n -------------------------------------------------------------------------------$brk------------------------40. List of Stopped components - EGs, flows  (Stopped) : $brk "
cat $LOG | grep -i stop

#echo -e "\n ---------------------------------------------------------------------------$brk----------------------------41 stopped commands - EG : $brk "
#cat $LOG | grep -i stop

echo -e "\n ----------------------------------------------------------------------------$brk---------------------------41-42 mqsistop commands(EGs) for V12"
mqsilist $brk | grep -i stop | awk -F "'" '{print "mqsistop BRK -e "$2}'

echo -e "\n ---------------------------------------------------------------------------$brk----------------------------43. BIP1278I - mqsistop commands(flows) for V12"
cat $LOG| grep -i stop | grep BIP1278I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k " $6 " -m "$2}'

echo -e "\n -----------------------------------------------------------------------------$brk--------------------------44. BIP1289I(no App) - mqsistop commands(flows) for V12"
cat $LOG| grep -i stop | grep BIP1289I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k  App" " -m "$2}'

echo -e "\n -----------------------------------------------------------------------------$brk--------------------------45.  mqsistop commands(Applications) for V12"
cat $LOG| grep -i stop | grep BIP1276I | awk -F "'" '{print "mqsistopmsgflow Broker -e " $4 " -k " $2}'

echo -e "\n---------------------------------------------------------------------------------$brk-----------------------46. $tag  16-12 - maxThreads of Egs $(date +%Y-%m-%d_%H-%M-%S)"
LOG=maxThreads.$brk.$tag.12
>$LOG
echo -e "\n--------------------------------------------------------------------------------$brk-------------------- 47. $tag  maxThreads of EGs - Brk $brk" >> $LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "HTTPConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxThreads  >> $LOG
   echo -e "HTTPSConnector - maxThreads - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxThreads  >> $LOG
   ((ENO=ENO+1))
done  
cat $LOG | grep maxThreads | grep -v HTTP
echo -e "\n-------------------------------------------------------------------------------$brk--------------------48. $tag  17-13 - maxHttpHeaderSize of Egs $(date +%Y-%m-%d_%H-%M-%S)"
LOG=maxHttpHeaderSize.$brk.$tag.13
>$LOG
echo -e "\n -----------------------------------------------------------------------------$brk--------------------49. $tag  maxHttpHeaderSize of : $brk " >>$LOG
ENO=1
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do    
   echo -e "HTTPConnector - maxHttpHeaderSize - $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   echo -e "HTTPSConnector - maxHttpHeaderSize - $brk - $eg($ENO)"  >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i maxHttpHeaderSize  >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\n ---------------------------------------------------------------------------$brk---------------------50. $tag  maxHttpHeaderSize of EGs : $brk "
cat maxHttpHeaderSize.$brk.$tag.13 | grep maxHttpHeaderSize | grep -v "=''" | grep -v HTTP -B1
echo -e "\n -----------------------------------------------------------------------------$brk-------------------51. $tag  maxHttpHeaderSize of All EGs : $brk "
cat maxHttpHeaderSize.$brk.$tag.13 | grep "maxHttpHeaderSize=''"
echo -e "\n----------------------------------------------------------------------------$brk---------------------52. $tag  18-14 - tls of all EGs $(date +%Y-%m-%d_%H-%M-%S)"
LOG=tlsssl.$brk.$tag.14
>$LOG
echo -e "-------------------------------------------------------------------------------$brk---------------53. $tag  Broker Prop of tls $brk " >> $LOG
echo -e "-------------------------------------------------------------------------------$brk---------------54. $tag  Broker $brk - ssl " >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i ssl >> $LOG
echo -e "-------------------------------------------------------------------------------$brk---------------55. $tag  Broker $brk - tls " >> $LOG
mqsireportproperties $brk -b httplistener -o HTTPSConnector -r | grep -i tls >> $LOG
ENO=1
echo -e "--------------------------------------------------------------------------------$brk--------------56. $tag  Collecting for tls, ssl for EGs" >> $LOG
for eg in `mqsilist $brk | grep running | sort -n |awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
   echo -e "Prop of tls $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i tls >> $LOG
   echo -e "Prop of ssl $brk - $eg($ENO)" >> $LOG
   mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep -i ssl >> $LOG
   ((ENO=ENO+1))
done 
echo -e "\n ------------------------------------------------------------------------------$brk------------57. $tag   Content of tlsssl file "
cat $LOG | grep TLS -B1
echo -e "\n ------------------------------------------------------------------------------$brk--------------------------58. $tag   tls ssl of : $brk "
cat $LOG | grep TLS -B1
echo -e "\n ------------------------------------------------------------------------------$brk--------------------------59. $tag   Total EGs to execute (#/2 pls) $brk "
cat $LOG | grep "sslProtocol='TLSv1.2'" | wc -l
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

echo -e "\n--------------------------------------------------------------------------$brk------------------60. $tag  19-15 - webconsole $(date +%Y-%m-%d_%H-%M-%S)"
echo -e "\n---------------------------------------------------------------------------$brk-----------------61. $tag - Broker port"
mqsilist | grep $brk
LOG=webconsole.$brk.$tag.15
>$LOG
mqsiwebuseradmin $brk -l >> $LOG
echo -e "\n -------------------------------------------------------- mqsiwebuseradmin : $brk "
cat $LOG
echo -e "\n---------------------------------------------------------------------------$brk-----------------62. $tag  20 - Line number of brokerstart.sh"
cat -n /WebSphere/scripts/middleware/brokerstart.sh | grep $brk
echo -e "/WebSphere/scripts/middleware/brokerstart.sh -> This script needs to be update"
echo -e "\n------------------------------------------------------------------------------$brk--------------63. $tag  21-16 - Collecting all SSL prop of all EGs"
LOG=AllSSLProperties.$brk.$tag.16
>$LOG
/WebSphere/scripts/middleware/ace/AllSslPropEgs.sh $brk 16 $tag > $LOG
echo -e "\n-------------------------------------------------------------------------$brk-------------------64. $tag  22-17 - Collecting all prop of all EGs"
LOG=AllPropEgs.$brk.$tag.17
>$LOG
/WebSphere/scripts/middleware/ace/AllPropEgs.sh $brk 17 $tag > $LOG
echo -e "\n----------------------------------------------------------------------------$brk----------------65. $tag  23-18 - Collecting all flows with status"
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

echo -e "\n-----------------------------------------------------------------------------$brk---------------66. $tag  24 - MQTT properties and commands"
mqsireportproperties $brk -b pubsub -o MQTTServer -r

echo "mqsireportproperties $brk -b pubsub -o MQTTServer -r"
echo "mqsichangeproperties $brk -b pubsub -o MQTTServer -n enabled -v false"
echo "mqsichangeproperties $brk -b pubsub -o MQTTServer -n port -v '0'"
echo "mqsireportproperties $brk -b pubsub -o MQTTServer -r"

echo -e "\n---------------------------------------------------------------------------------$brk-----------67. $tag  Health of the qmgr"
health | grep $brk
pwd


echo -e "\n---------------------------------------------------------------------------------$brk-----------68. $tag  25 - List of all Files"
pwd
ls -lrt *
echo -e "\nSuccessfully completed - Bye Bye"
echo "----> Completed <----"
