#JS
#/WebSphere/scripts/middleware/rmExpCerts.sh
#!/bin/bash

# Improvements
#change the output to single line , reason if you want to validate truststure which has more number of expired certs - it will take more time to run through the script , we can enhance the script later. by combining the scripts to list the certs and this one into one script 
#list the certs  and its validity next to it 
#delete the selected label fromt he jks , that way everything is one place 
#something like this /WebSphere/scripts/middleware/rmExpCerts.sh <list/delete> jksFile jskPwd
#later we have to combine all of them to create master report , which can give you the snapshot of entire environment 


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
      #echo -e "\nAlias: $line - EXPIRED on: $expiry_date\nCan we delete since it is expired? (y/Y) : "
      #>$answer
      #read -r answer      
      read -p "Do you want to delete it? (y/Y to confirm): " answer </dev/tty
      echo -e "\nGiven answer is --$answer--"
      if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
         #echo -e "\nGiven $jksFile contains below number of certs : "
         #keytool -list -keystore $jksFile -storepass $jskPwd | grep "Your keystore contains"
         printNumber
         keytool -delete -keystore $jksFile -storepass $jskPwd -alias $line
         #sleep 10s      
         #echo -e "\nGiven $jksFile contains below number of certs : "
         #keytool -list -keystore $jksFile -storepass $jskPwd | grep "Your keystore contains"
         printNumber
         echo -e "-------------------------------Deleted-------------------------------"            
      else
         echo -e "-------------------------------Not Deleted---------------------------"
      fi
   else    
      echo -e "----------------------------------Not Expired : No action----------------------------------"
   fi
   ((SNO=SNO+1))
done < /tmp/certs
echo -e "--------------------------------------- Completed -------------------------------"