# JS
# /WebSphere/scripts/middleware/qstatusMl.sh
#*/15 * * * * /WebSphere/scripts/middleware/qstatusMl.sh >/dev/null 2>&1

#!/bin/bash

LOG=/tmp/qstat.log
LOG1=/tmp/qstat1.log
email='q17020@cusa.canon.com'
host="qstat:`uname -n`"

for j in 7 10 12
do
   . /WebSphere/scripts/middleware/wmbprofile $j >> /dev/null
   for qmgr in `dspmq|awk -F"[(*)]" '{print $2}'`
   do
      #echo -e "Name of the qmgr : $qmgr"
      echo "dis ql(*) where(curdepth gt 0)"|runmqsc $qmgr|egrep "QUEUE|CURDEPTH"|awk '$1 ~ /QUEUE/ {printf $1}; $2 ~ /CURDEPTH/ {print " "$2};$1 ~ /CURDEPTH/ {print $1};'|awk -F"[(*)]" '{printf  " %-10s  : %-40s   :  %-5s  \n","'"$qmgr"'",$2,$4}' |sed -e '/SYSTEM.DEAD.LETTER.QUEUE/p' -e '/SYSTEM.CLUSTER.TRANSMIT.QUEUE/p' -e '/SYSTEM.*/d' >> $LOG
   done #for end
done #for end

# Compare the files and send mail if required.
if [[ -s /tmp/qstat.log ]]; then
  if [[ -s /tmp/qstat.log_prev1 ]]; then
    #Different files
    if [[ `diff /tmp/qstat.log /tmp/qstat.log_prev1` ]];then cat $LOG|mail -r "noreply-qstat@cusa.canon.com" -s "$host" "$email"
    else
      #No changes from the previouls run.
      host="2:NotOkay-70%>Qs-No Change from Prev file-`uname -n`"
      email='q17020@cusa.canon.com'
    fi
  # New file is create
  else cat $LOG|mail -r "noreply-qstat@cusa.canon.com" -s "$host" "$email"
  fi
fi
mv /tmp/qstat.log /tmp/qstat.log_prev1