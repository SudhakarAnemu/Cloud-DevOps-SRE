#JS
#/WebSphere/scripts/middleware/ListoutExpiryCerts.sh
#!/bin/bash



#Assigning environment variables
jksFile=$1
jskPwd=$2
echo -e "\nTaking backup of the script"
cp $jksFile $jksFile.Bk.$(date +%Y-%m-%d_%H-%M-%S)
printNumber() {
   echo -e "\nGiven $jksFile contains below number of certs : "
   keytool -list -keystore $jksFile -storepass $jskPwd | grep "Your keystore contains"
}
printNumber
keytool -list -keystore $jksFile -storepass $jskPwd | grep Entry | awk -F"," '{print $1}' | sort > /tmp/certs
SNO=1
answer=''
while IFS= read -r line
do
   echo -e "\nExpiry of the Label : $line"
   keytool -list -v -keystore $jksFile -storepass $jskPwd -alias $line 2>/dev/null | grep "Valid from"
   expiry_date=$(keytool -list -v -keystore $jksFile -storepass $jskPwd -alias $line 2>/dev/null | grep "Valid from" | awk -F" " '{print $7}')
   valid_date=$(keytool -list -v -keystore $jksFile -storepass $jskPwd -alias $line 2>/dev/null | grep "Valid from" | awk -F" " '{print $3}')
   expiry_epoch=$(date -d "$expiry_date" +%s)
   current_epoch=$(date +%s)
   echo -e "\nS.No:$SNO\tLabel:--$line--\tValidFrm:--$valid_date--\tExpiry:--$expiry_date--\texpiry_epoch:--$expiry_epoch--\tcurrent_epoch:--$current_epoch-------------------------------------"
   if [[ "$expiry_epoch" -lt "$current_epoch" ]]; then
      echo -e "----------------------------------Expired : Action----------------------------------"    
   else    
      echo -e "----------------------------------Not Expired : No action----------------------------------"
   fi
   ((SNO=SNO+1))
done < /tmp/certs
echo -e "--------------------------------------- Completed -------------------------------"