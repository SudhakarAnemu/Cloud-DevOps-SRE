
#js
#!/bin/bash
#/WebSphere/scripts/middleware/addTrustToEgs.sh brk

brk=$1
while IFS= read -r eg
do
  echo "mqsichangeproperties $brk -e $eg  -o ComIbmJVMManager -n truststoreType,truststoreFile,truststorePass -v JKS,/WebSphere/wmbconfig/tst/truststore/wmbtruststore.jks,$eg::truststorePass"
  echo "mqsisetdbparms $brk -n $eg::truststorePass -u ignore -p wmbtruststore"
  #echo "mqsichangeproperties $brk -e $eg -o HTTPSConnector -n TLSProtocols -v 'TLSv1.2'"
done < egnames




#js
#Input : 
#Output : 
#js.sh filename brokername
#!/bin/bash
SNO=1
file=$1
brk=$2
echo "Given file : $file"

while IFS= read -r line
do
    #echo "S.No : $SNO - Line : $line"
    IFS=":" read -ra fields <<< "$line"
    eg="${fields[0]}"
    jkspath="${fields[1]}"
echo "mqsichangeproperties $brk -e $eg  -o ComIbmJVMManager -n keystoreFile -v $jkspath"
    ((SNO=SNO+1))

done < $file
