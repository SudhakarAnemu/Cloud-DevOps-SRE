#JS 

#!/bin/bash
#/WebSphere/scripts/middleware/listURLEgAllBrkrs.sh
#for i in 7 9 10
for ver in 7 9 10 12
do
      . /WebSphere/scripts/middleware/wmbprofile $ver >> /dev/null
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
            for eg in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}'`
            do
                echo "---------------------------------------Version : $ver ---------- I am checking for $brk - $eg-------"   
                mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep "url="
            done
      done
done

 
----> For specific broker : 


#!/bin/bash
#/WebSphere/scripts/middleware/listURLEgAllBrkrSpecific.sh
brk=$1
for eg in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}'`
do
      echo "---------------------------------------Version : $ver ---------- I am checking for $brk - $eg-------"   
      mqsireportproperties $brk -e $eg -o HTTPSConnector -r | grep "url="
done






 #mqsireportproperties brk -e eg -o HTTPSConnector -r | grep "url="