

#---------------------------> Capture for one broker. 

#/WebSphere/scripts/middleware/portlist1Brk.sh
brk=$1
#for i in 7 9 10
#for i in 9 10 12
#do
      #. /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
      #for j in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      #do
            for eg in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}'`
            do
                  port=`mqsireportproperties $brk -e  $eg  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
                  if [[ ! -z $port ]]; then
                        echo  "$brk - $eg - $port "
                  fi
            done
      #done
#done


#How to run 
#/WebSphere/scripts/middleware/portlist1Brk.sh Brk
