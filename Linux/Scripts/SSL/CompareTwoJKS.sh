
#js
#Example :
# /WebSphere/scripts/middleware/CompareTwoJKS.sh /WebSphere/wmbconfig/dev/truststore/wmbtruststore.jks wmbtruststore /WebSphere/wmbconfig/dev/keystore/v10/s21r3pr/cybersource.jks cybersource

#js
#!/bin/bash
fJks=$1
fPwd=$2
sjks=$3
sPwd=$4

echo -e "\n First jks : ---$1--- pwd : ---$2---"
echo -e "\n Second jks : ---$3--- pwd : ---$4---"

keytool -list -keystore $1 -storepass $2 | grep fingerprint | awk -F" " '{print $4}' > file1

keytool -list -keystore $3 -storepass $4 | grep fingerprint | awk -F" " '{print $4}' > file2

/WebSphere/scripts/middleware/check_lines.sh file1 file2

echo -e "\n--------------- Finger prints which does not exists --------------- "
cat /tmp/DNExists

echo -e "\n------------- Lables and expiry basedon the Finger prints"

ENO=1
while IFS= read -r finger;
do
   label=`keytool -list -keystore $sjks -storepass $sPwd | grep $finger -B 1 | grep trustedCertEntry | awk -F"," '{print $1}'`
   echo -e "\nS.No : $ENO, Label is ---$label---"
   echo -e "\nExpiry ................................. "
   keytool -list -keystore $sjks -storepass $sPwd -alias "$label" -v | grep Valid   
   ((ENO=ENO+1))
done < /tmp/DNExists

>/tmp/DNExists

echo -e"\n------------------------------------ Completed ------------------------------------"