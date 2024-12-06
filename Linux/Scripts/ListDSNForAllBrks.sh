#js
#Input : 
#Output : 
#/WebSphere/scripts/middleware/ListDSNForAllBrks.sh
#!/bin/bash
LOG=DSNList.$(date +%Y-%m-%d_%H-%M-%S).log
>$LOG

echo -e "\n-------------------------------------- Checking dsn for all brks" >> $LOG
SNO=1
for brkrs in ` mqsilist | grep -i running | sort -n | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`;   do
   echo -e "-------------------------------------------------------------------------------------------"SNO : $SNO -- Broker : $brkrs >> $LOG
   echo -e "Checking mqsicvp for the Broker : $brkrs" >> $LOG
   mqsicvp $brkrs | grep 'Verification passed for User Datasource' >> $LOG
   echo -e "Checking mqsireportdbparms for the Broker : $brkrs" >> $LOG
   mqsireportdbparms $brkrs -n \* | grep -v '::' >> $LOG
   ((SNO=SNO+1))
done
echo "Script successfully completed"