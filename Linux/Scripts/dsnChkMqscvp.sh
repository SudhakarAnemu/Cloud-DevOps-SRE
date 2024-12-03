
#js
#Input : 
#Output : 
#/WebSphere/scripts/middleware/dsnChkMqscvp.sh
#!/bin/bash
SNO=1
log=fulldsnoutput.log
>$log
while IFS= read -r line
do
    #echo "S.No : $SNO - Line : $line"
    IFS=":" read -ra fields <<< "$line"
    brk="${fields[0]}"
    dsn="${fields[1]}"
    uid="${fields[2]}"
    pwd="${fields[3]}"
    #echo -e "SNO:$SNO--Broker:$brk--DSN:--$dsn--uid:--$uid--Pwd:--$pwd--"
    echo -e "SNO:$SNO--Broker:$brk--DSN:--$dsn--uid:--$uid--Pwd:--$pwd--" >> $log
    echo -e "----- Lets verify the Line number of $dsn" >> $log
    cat -n /var/mqsi/odbc/.v12_odbc.ini | grep $dsn >> $log
    mqsicvp -n $dsn -u $uid -p $pwd >> $log


    count=`mqsicvp -n $dsn -u $uid -p $pwd | grep -i datasourceServerName | wc -l`

    server=`mqsicvp -n $dsn -u $uid -p $pwd | grep -i datasourceServerName | awk -F"=" '{print $2}'`
    
    if [ $count == 1 ]; then  
        echo -e "S.No:$SNO-Passed for the dsn - $dsn, server-$server,user:$uid,pwd:$pwd"
    elif [ $count == 0 ]; then  
        echo -e "S.No:$SNO-Failed for the dsn - $dsn, server-$server,user:$uid,pwd:$pwd"
    fi
    ((SNO=SNO+1))

done < dsnfile
