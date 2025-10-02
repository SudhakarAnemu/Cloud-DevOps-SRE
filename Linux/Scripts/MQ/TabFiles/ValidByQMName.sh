#js
#!/bin/bash
#/WebSphere/scripts/middleware/ValidByQMName.sh qmlist queue
queue=$2
SNO=1
while IFS= read -r line
do
    #qmname=$(echo "$line" | sed 's/ //g')
    qmname=$line
    #echo "S.No : $SNO -------- QMName : ---$qmname---"
    #qmname=$(echo "$line" | tr -d ' ')    
    qmname="${line//[[:space:]]/}"
    #qmname="${line// /}"
    echo "S.No : $SNO -------- QMName : ---$qmname---"
    #/opt/mqm92/samp/bin/amqsputc "$queue" *"$qmname"
    #/opt/mqm92/samp/bin/amqsgetc "$queue" *"$qmname"
    /opt/mqm92/samp/bin/amqscnxc *"$qmname"

    ((SNO=SNO+1))
done < $1
