#js 


#/WebSphere/scripts/middleware/checkPortProcess.sh
cd /WebSphere/scripts/middleware/
#rm -f port_output.txt
#./portlist.sh >> port_output.txt
# Below one is output of - /WebSphere/scripts/middleware/portlist.sh
input="/WebSphere/scripts/middleware/port_output.txt"
cat $input|awk -F"-" '{print $1,$2,$3}'|while read broker eg port
do
#echo -n $port
if [[ $port  -ne '' || $port -ne 0 ]]; then
 listeningPID=`netstat -anp 2>/dev/null |grep $port|grep 'LISTEN'|awk '{ print $NF}'|awk -F"/" '{print $1}'`
 liseningProcess=`ps -ef|grep $listeningPID|grep DataFlowEngine |awk '{print $NF}'`
 if [[ $liseningProcess -ne $eg ]]; then
    echo   "----- need to kill process $broker $eg $port -----"
  #else
  #  echo  "correct process listening $broker $eg $port"
  fi
fi
done

#for i in `cat port_output.txt|awk -F"-" '{print $2,$3,$4}'`; do listeningPID=`netstat -anp|grep $4|grep 'LISTEN'|awk '{ print $NF}'|awk -F"/" '{print $1}'`; lisenPID=ps -ef|grep $listeningPID|grep DataFlowEngine |awk '{print $NF}'
# port : 19128
# netstat -anp 2>/dev/null |grep 19128|grep 'LISTEN'|awk '{ print $NF}'|awk -F"/" '{print $1}'

#Ex : 
#WMBQB26 - s21ibods_eg1 - 0
#WMBAB26 - s21ibx_vertex_eg1 - 0
#WMBAB26 - s21ib_cusartex_eg1 - 0
#WMBAB26 - s21ib_cyberrce_eg1 - 0
#WMBAB26 - s21ib_mone_eg1 - 0
#MBQ3B26 - s21ib_paymtech_eg1 - 0
