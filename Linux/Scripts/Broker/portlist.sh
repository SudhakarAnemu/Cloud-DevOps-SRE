#/WebSphere/scripts/middleware/portlist.sh
#for i in 7 9 10
for i in  9 10 12
do
      . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
      for j in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
            for k in `mqsilist $j|grep BIP1286I|awk -F"'" '{print $2}'`
            do
                  port=`mqsireportproperties $j -e  $k  -o HTTPSConnector -n explicitlySetPortNumber|grep -v BIP8071I|tr -d '\n'`
                  if [[ ! -z $port ]]; then
                        echo  "$j - $k - $port "
                  fi
            done
      done
done