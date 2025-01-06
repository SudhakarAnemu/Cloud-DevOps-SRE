#js 

# /WebSphere/scripts/middleware/aliasByFprnt.sh jks pwd fprint

#!/bin/bash

jksFl=$1
jksPwd=$2
fprint=$3

echo -e "\nWe need to find Lable for jks:--$jksFl--:pwd:--$jksPwd--:fPrint--$fprint--"
#label=`keytool -list -keystore wmbtruststore.jks -storepass wmbtruststore | grep 91:7E:73:2D:33:0F:9A:12:40:4F:73:D8:BE:A3:69:48:B9:29:DF:FC -B 1 | grep trustedCertEntry | awk -F"," '{print $1}'`
label=`keytool -list -keystore $jksFl -storepass $jksPwd | grep $fprint -B 1 | grep Entry | awk -F"," '{print $1}'`
echo -e "\nLabel is ---$label---"





#keytool -list -keystore ofsapistg.jks -storepass ofsapistg | grep 75:05:8F:8E:6A:1E:CD:27:EE:DD:DF:1E:BC:17:C7:56:03:1D:BF:FB -B 1 | grep trustedCertEntry | awk -F"," '{print $1}'