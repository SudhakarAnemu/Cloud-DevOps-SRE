#js - Verify http and https listeners are up or not. 




for i in `cat data.txt|awk -F"-" '{print $4}'|cut -d":" -f2`; do echo " --------- Testing HTTP port : $i ----------"; netstat -an |grep $i; done

for i in `cat data.txt|awk -F":" '{print $2}'|cut -d"-" -f1`; do echo " -------- Testing HTTPS $i -------"; netstat -an |grep $i; done


for i in `cat HttpHttpsPorts.IIBT1AB34.v10.8 | awk -F"-" '{print $4}' | grep -v ":0" | cut -d":" -f2`; do echo " --------- Testing HTTP port : $i ----------"; netstat -an |grep $i; done


for i in `cat HttpHttpsPorts.IIBT1AB34.v10.8 | awk -F"-" '{print $2}' | grep -v ":0" | cut -d":" -f2`; do echo " --------- Testing HTTPS port : $i ----------"; netstat -an |grep $i; done




