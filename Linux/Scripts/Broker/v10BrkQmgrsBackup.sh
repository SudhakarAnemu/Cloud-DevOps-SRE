# js sudha
# Usage : /WebSphere/scripts/middleware/v10BrkQmgrsBackup.sh path broker qmgr
#Example :
# /WebSphere/scripts/middleware/v10BrkQmgrsBackup.sh /home/wmbadmin/acebkp/IIBDVAA21 IIBDVAA21 IIBDVAA21
#!/bin/bash
path=$1
brk=$2
qmgr=$3
echo -e "Path : $1, Broker : $2, Qmgr : $3"

# Capture qmgr backup
#cd /var/mqm/qmgrs/
#tar -cvf $path/$qmgrmqfs.tar $qmgr
# Capture mqsc and auth
cd $path
dmpmqcfg -m $qmgr -t all -x all -o mqsc -a -o 1line > $qmgr.mqsc
amqoamd -m $qmgr -s > $qmgr.auth

#Broker backup
cd $path
mqsibackupbroker $brk -d .

#cd /var/mqsi/components
#tar -cvf $path/$brkfs.tar $brk

