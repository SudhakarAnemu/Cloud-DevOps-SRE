#js

#/WebSphere/scripts/middleware/stoppedComponents.sh
brk=$1
LOG=AllFlowStatus.$brk.$(date +%Y-%m-%d_%H-%M-%S).log
>$LOG
echo -e "\n-------------------------------------- Running EGs - Brk $brk" >> $LOG

   for eg in `mqsilist $brk | sort -n  | grep BIP1286I | awk -F" " '{print $4}' | awk -F"'" '{print $2}'`; do
      echo -e "\n---------------- apps on eg : "  >> $LOG
      mqsilist $brk -e  $eg >> $LOG
      echo -e "\n---------------- apps on eg with -r: "  >> $LOG
      mqsilist $brk -e  $eg -r >> $LOG
      echo "---------------" >> $LOG
   done 

echo -e "\n --------- Count of stopped - EGs, flows  (Stopped) : $brk "
cat -n AllFlowStatus.$brk.11.1 | grep -i stop | wc -l

echo -e "\n --------- Stopped components - EGs, flows  (Stopped) : $brk "
cat -n AllFlowStatus.$brk.11.1 | grep -i stop

