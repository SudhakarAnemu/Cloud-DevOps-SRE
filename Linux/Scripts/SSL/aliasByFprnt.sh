#js 

# /WebSphere/scripts/middleware/aliasByFprnt.sh jks pwd fprint

#!/bin/bash

jksFl=$1
jksPwd=$2
fprint=$3

echo -e "\nWe need to find Lable for jks:--$jksFl--:pwd:--$jksPwd--:fPrint--$fprint--"
label=`keytool -list -keystore wmbtruststore.jks -storepass wmbtruststore | grep 91:7E:73:2D:33:0F:9A:12:40:4F:73:D8:BE:A3:69:48:B9:29:DF:FC -B 1 | grep trustedCertEntry | awk -F"," '{print $1}'`
echo -e "\nLabel is ---$label---"

