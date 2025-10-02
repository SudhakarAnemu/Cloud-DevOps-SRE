#js 

#!/bin/bash
#/WebSphere/scripts/middleware/ace/egOvridJksList.sh <Broker>
# List out All override properties of the EGs based on the Broker. 
brk=$1
tag=$2
log=$brk.$tag.egOvridJksList
>$log
cd /var/mqsi/components/$brk/servers/
find ./ -name server.conf.yaml |grep overrides > /tmp/egs
echo -e "Collecting override properties of all EGs"
SNO=1
while IFS= read -r line
do   
   echo -e "-----/var/mqsi/components/$brk/servers/--$line--------------- $brk----------------- $SNO"
   echo "SNo : $SNO - List - Name of the EG : $line - $brk"
   egrep 'jks|store|HTTP|JVM' $line 
   echo "SNo : $SNO - Count - Name of the EG : $line - $brk" 
   egrep 'jks|store|HTTP|JVM' $line|wc -l 
   echo "SNo : $SNO - Count - Name of the EG : $line - $brk" 
   echo -e "Number of KeystoreFile : " 
   cat $line | grep -i KeystoreFile| wc -l 
   echo -e "Number of keystorePass : " 
   cat $line | grep -i keystorePass| wc -l 
   echo -e "Number of TruststoreFile : " 
   cat $line | grep -i TruststoreFile| wc -l 
   echo -e "Number of truststorePass : " 
   cat $line | grep -i truststorePass| wc -l 
   echo -e "Number of JKS : " 
   cat $line | grep JKS| wc -l 
   echo "SNo : $SNO - mq(mqtt) - Name of the EG : $line - $brk"
   egrep 'mq|mqtt' $line    
   ((SNO=SNO+1))
done < /tmp/egs
echo "---------------------- Completed --------------------"


#for i in `find ./ -name server.conf.yaml |grep overrides`; do echo "--- $i -----"; egrep 'jks|store|HTTP|JVM' $i; done
#for i in `find ./ -name server.conf.yaml |grep overrides`; do echo "--- $i -----"; egrep 'jks|store|HTTP|JVM' $i|wc -l; done
#for i in `find ./ -name server.conf.yaml |grep overrides`; do echo "--- $i -----"; egrep 'mq' $i; done