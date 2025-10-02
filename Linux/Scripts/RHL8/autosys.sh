#js 

for i in ./tst1/scripts/autosys-wmb/hrsups/wmbAutosysProxyInbound.sh ./tst1/scripts/autosys-wmb/hrsups/wmbAutosysProxyDummy.sh ./tst1/scripts/autosys-wmb/hrsups/wmbAutosysProxy2.sh ./tst1/scripts/autosys-wmb/hrsups/s21r3pr_invokewmb.sh ./tst2/scripts/autosys-wmb/peoplesoft/s21r3pr_invokewmb.sh ./tst2/scripts/autosys-wmb/peoplesoft/wmbAutosysProxy2.sh ./tst2/scripts/autosys-wmb/peoplesoft/wmbAutosysProxyDummy.sh ./tst2/scripts/autosys-wmb/peoplesoft/wmbAutosysProxyInbound.sh ./tst2/scripts/autosys-wmb/s21parts_cci/DV1/edi/dummy.sh ./tst2/scripts/autosys-wmb/s21parts_cci/DV1/edi/dummy1.sh ./tst2/scripts/autosys-wmb/s21parts_cci/DV1/edi/s21whscciparts_invokewmb.sh ./tst2/scripts/autosys-wmb/s21parts_cci/DV1/sqlin/s21partscci_invokewmb.sh ./tst2/scripts/autosys-wmb/s21parts_cci/DV1/sqlout/s21partscci_invokewmb.sh ./tst2/scripts/autosys-wmb/hrsups/s21r3pr_invokewmb.sh ./tst2/scripts/autosys-wmb/hrsups/wmbAutosysProxy2.sh ./tst2/scripts/autosys-wmb/hrsups/wmbAutosysProxyDummy.sh ./tst2/scripts/autosys-wmb/hrsups/wmbAutosysProxyInbound.sh
do
     backupname=`echo $i"_20250719"`
     OLD_PATH="/opt/ibm/JRE1.6_32/java/bin/java"
     NEW_PATH="/opt/ibm/ibmjre/jre/bin/java"
     echo $i
     sudo cp -p $i $backupname
     if [[ ! -e $backupname ]]; then
          echo "not able to backup of file : $backupname " >> /tmp/error.txt
          echo "--------- not able to backup of file : $backupname "
     fi
     sudo sed -i "s|${OLD_PATH}|${NEW_PATH}|g" $i
done