#/WebSphere/scripts/middleware/checkPortProcess1Brk.sh
brk=$1
rm -f /tmp/1Brkport_output.txt
for eg in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}'`
do
    port=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
    if [[ ! -z $port ]]; then
        echo  "$brk - $eg - $port " >> /tmp/1Brkport_output.txt
    fi
done
echo -e "--------Port numbers of the Broker : $brk"
cat -n /tmp/1Brkport_output.txt
echo -e "---------------------------------------------------------------------------------------------------------------------"
input="/tmp/1Brkport_output.txt"
ENO=0
cat $input|awk -F"-" '{print $1,$2,$3}'|while read broker eg port
do
   ((ENO=ENO+1))
   echo -e "$ENO ---- Checking for the Port - $port"
   if [[ $port  -ne '' || $port -ne 0 ]]; then
      listeningPID=`netstat -anp 2>/dev/null |grep $port|grep 'LISTEN'|awk '{ print $NF}'|awk -F"/" '{print $1}'`
      liseningProcess=`ps -ef|grep $listeningPID|grep DataFlowEngine |awk '{print $NF}'`
      if [[ $liseningProcess -ne $eg ]]; then
         echo -e "$ENO----- need to kill process $broker $eg $port -----"
      else
         echo -e "$ENO----- Correct process listening $broker $eg $port"
      fi
   fi
done


----------------------------->>> For all Brokers; : 


#/WebSphere/scripts/middleware/checkPortProcessAllBrk.sh --> ALL Brks
SNO=1
for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
do
    echo -e "\nS.no : $SNO - Broker : $brk -------------------- "
    /WebSphere/scripts/middleware/checkPortProcess1Brk.sh $brk
    ((SNO=SNO+1))
done




netsta -anp | grep listen  --> 

VM[wmbadmin@varhdv122 ~] netstat -anp | grep 20025
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:20025           0.0.0.0:*               LISTEN      84335/biphttplisten
VM[wmbadmin@varhdv122 ~] ps -ef | grep biphttplisten
wmbadmin  28911  28855  0 Jun20 ?        00:26:22 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT2AB30
wmbadmin  30001  29957  0 Jun20 ?        00:25:04 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT1AA21
wmbadmin  31760  31651  0 Jun20 ?        00:31:12 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener WMBT1AA26
wmbadmin  33143  33101  0 Jun20 ?        00:26:24 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT1AA30
wmbadmin  38328  38297  0 Jun20 ?        00:26:45 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT2AB24
wmbadmin  40254  40220  0 Jun20 ?        00:27:45 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT2AB23
wmbadmin  75813  75780  0 Jun20 ?        00:33:15 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener WMBT2AB26
wmbadmin  78657  70510  0 15:23 pts/2    00:00:00 grep --color=auto biphttplisten
wmbadmin  84335  84307  0 10:55 ?        00:00:41 /opt/ibm/mqsi/v12/ace-12.0.4.0/server/bin/biphttplistener IIBT2AB25
VM[wmbadmin@varhdv122 ~]
