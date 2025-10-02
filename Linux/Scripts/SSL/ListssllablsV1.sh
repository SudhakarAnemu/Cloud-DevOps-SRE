#!/bin/bash
#/WebSphere/scripts/middleware/ListssllablsV1.sh <jks> <pwd>
# JS - check details of Labels.
echo "First parameter : $1"
keytool -list -keystore $1 -storepass $2 | grep -v fingerprint | grep -v Keystore | grep -v keystore | awk -F"," '{print $1}' | grep -v '^[[:space:]]*$' | sort > /tmp/alllbls
echo "------------------ Lables of the jks file : "
keytool -list -keystore $1 -storepass $2
echo "------------------ All labels : "
cat -n /tmp/alllbls
SNO=1
while IFS= read -r line
do
   echo "SNO : $SNO~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   echo "Name of the Label : $line"
   keytool -list -keystore $1 -storepass $2 -alias "$line" -v > /tmp/del
   #echo -e "Serial Number : "
   cat /tmp/del | grep 'Serial number'
   #echo -e "Owner | Issuer | Expiry"
   cat /tmp/del | grep -E "Valid|Owner|Issuer"
    ((SNO=SNO+1))
done < /tmp/alllbls

# keytool -list -keystore $1 -storepass $2 -alias "$line" -v | grep -E "Valid|Owner|Issuer"