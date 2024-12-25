#!/bin/bash
#/WebSphere/scripts/middleware/Listssllabls.sh <jks> <pwd>
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
   echo "Serial Number : ................................. "
   keytool -list -keystore $1 -storepass $2 -alias "$line" -v | grep 'Serial number'
   echo "Expiry : ................................. "
   keytool -list -keystore $1 -storepass $2 -alias "$line" -v | grep Valid
   echo "CN Name : ................................. "
   keytool -list -keystore $1 -storepass $2 -alias "$line" -v | grep Owner
   echo "Issuer Name : ................................. "
   keytool -list -keystore $1 -storepass $2 -alias "$line" -v | grep Issuer
    ((SNO=SNO+1))
done < /tmp/alllbls
