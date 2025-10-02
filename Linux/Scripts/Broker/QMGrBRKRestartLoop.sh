
#/WebSphere/scripts/middleware/BRKRestartLoop.sh


#!/bin/bash
my_array=("WMBPRAC26" "IIBPRAC26" "WMBPRAC23" "IIBPRAC30" "WMBPRAC21" "IIBPRAC21" "IIBPRBC34" "IIBPRAC23")
echo "Iterating through the array:"
SNO=1
for item in "${my_array[@]}"; do
  echo "--------------------------------------------------------------$SNO Restarting the Broker - $item"
  /WebSphere/scripts/middleware/BRKRestart.sh $item
  ((SNO=SNO+1))
  echo -e "\n ---------------------------------------------------------------------------------------------------------------"
  echo -e "\n ***************************************************************************************************************"
  echo -e "\n ---------------------------------------------------------------------------------------------------------------"
done


----------------------------------------------------------------------------------------->>
#/WebSphere/scripts/middleware/BRKRestartLoopList.sh
#!/bin/bash
SNO=1
while IFS= read -r line
do
   echo -e "\nS.No : $SNO - Before Broker : ***$line***"   
   broker="${line//[[:space:]]/}"
   echo -e "\nS.No : $SNO - After Broker : ***$broker***"
   /WebSphere/scripts/middleware/BRKRestart.sh $broker
   ((SNO=SNO+1))
done < /tmp/brks


---------------------------------------------------------------------------------->> 

Restart all Brokers : 

#/WebSphere/scripts/middleware/BRKRestartLoopAll.sh
#!/bin/bash

SNO=1
for i in 7 9 10 12
do
      version=$i
      . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
      echo -e "\nI am listing Brokers for the version : $i - $version"
      mqsilist
      echo -e "i = $i, version = $version"
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
         echo -e "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         echo -e "\nS.No - $SNO - Version : $version Broker : $brk-----------------------------------------"
         /WebSphere/scripts/middleware/BRKRestart.sh $brk
         ((SNO=SNO+1))
      done
done

-------------------------------------------------------->> Stop all Brokers. 

#/WebSphere/scripts/middleware/StopAllBrksAndQmgrs.sh
#!/bin/bash

SNO=1
for i in 7 9 10 12 1212
do
      version=$i
      . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
      echo -e "\nI am listing Brokers for the version : $i - $version"
      mqsilist
      echo -e "i = $i, version = $version"
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
         echo -e "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         echo -e "\nS.No - $SNO - Version : $version Broker : $brk-----------------------------------------"
         perl /WebSphere/scripts/middleware/wmbRestart.pl $brk stop
         endmqm -i $brk         
         ((SNO=SNO+1))
      done
done

---> StOP ALL QMGRs. 

#/WebSphere/scripts/middleware/StopAllQMGRs.sh
#!/bin/bash

SNO=1
for i in 7 9 10 12 1212
do
      version=$i
      . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
      #echo -e "\nI am listing Brokers for the version : $i - $version"
      #mqsilist
      echo -e "i = $i, version = $version"
      for qmgr in `dspmq | grep Running | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
      do
         echo -e "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         echo -e "\nS.No - $SNO - Version : $version Qmgr : $qmgr-----------------------------------------"
         endmqm -i $qmgr         
         ((SNO=SNO+1))
      done
done

#/WebSphere/scripts/middleware/StopAllQMGRs1.sh
#!/bin/bash

SNO=1
 
      for qmgr in `dspmq | grep Running | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
      do
         echo -e "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         echo -e "\nS.No - $SNO - Version : $version Qmgr : $qmgr-----------------------------------------"
         endmqm -i $qmgr         
         ((SNO=SNO+1))
      done
 
#/WebSphere/scripts/middleware/StartAllQMGRs1.sh
#!/bin/bash

SNO=1
 
      for qmgr in `dspmq | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
      do
         echo -e "\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         echo -e "\nS.No - $SNO - Version : $version Qmgr : $qmgr-----------------------------------------"
         strmqm $qmgr         
         ((SNO=SNO+1))
      done
 


