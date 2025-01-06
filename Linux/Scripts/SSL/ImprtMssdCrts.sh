#JS 
# /WebSphere/scripts/middleware/ImprtMssdCrts.sh firstjks pwd secondjks pwd
# /WebSphere/wmbconfig/tst/truststore/wmbtruststore.jks
#js
#!/bin/bash
fJks=$1
fPwd=$2
sjks=$3
sPwd=$4
#mv *.cer old
>commandsToRun
>commandsExport
>/tmp/mfin
echo -e "\n------------------------------------------------------------------------------------------------------------"
echo -e "\nNumber of certs on first jks : $fJks"
keytool -list -keystore $fJks -storepass $fPwd | grep "Your keystore contains"
echo -e "\nNumber of certs on second jks : $sjks"
keytool -list -keystore $sjks -storepass $sPwd | grep "Your keystore contains"
/WebSphere/scripts/middleware/CompareTwoJKS.sh $fJks $fPwd $sjks $sPwd | grep "does not exist" | awk -F " " '{print $1}' > /tmp/mfin
echo -e "\nMissed finger prints : "
cat -n /tmp/mfin
echo -e "\nFinding labels, import and export"
ENO=1
while IFS= read -r line
do
   echo -e "\nS.No : $ENO, Working on the Finger --$line-- *******************************************************************"
   label=`keytool -list -keystore $sjks -storepass $sPwd | grep $line -B 1 | grep Entry | awk -F"," '{print $1}'`
   echo -e "\nLabel is ---$label---"
   echo -e "\nExporting the Cert from $sjks"
   keytool -exportcert -keystore $sjks -storetype jks -storepass $sPwd -file $label.cer -alias "$label"
   echo -e "keytool -exportcert -keystore $sjks -storetype jks -storepass $sPwd -file $label.cer -alias "$label"" >> commandsExport
   #echo -e "\nImporting the Cert to $fJks - Please run below commands ----------- S.No : $ENO"
   echo -e "keytool -importcert -keystore $fJks -storetype jks -storepass $fPwd -file $label.cer -alias "$label"" >> commandsToRun

   ((ENO=ENO+1))
done < /tmp/mfin
echo -e "\n----------------------------Content of commandsToRun"
cat commandsToRun
echo -e "\n----------------------------Commands to run : "
cat commandsToRun | grep importcert
echo -e "\n----------------------------Export commands : "
cat commandsExport
 
echo -e "\n--------------------- Completed ---------------------"