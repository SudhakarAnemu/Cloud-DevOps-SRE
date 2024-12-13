#js 

#/WebSphere/scripts/middleware/ace/CollFree.sh

LOG=/tmp/free
dt=`date +"%Y-%m-%d:%H-%M"`
free=`free -h | grep Mem`
req=$dt:$free
echo $req >> $LOG
