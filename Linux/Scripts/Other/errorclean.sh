js

cat /WebSphere/scripts/middleware/errqclean.sh


apperrorsdir=/WebSphere/mqbackup/apperrors
now=$(date +"%m%d%Y-%H%M")
mkdir -p $apperrorsdir/$now
cd $apperrorsdir/$now
>.temp.sh
for i in 7 9 12
do
    . /WebSphere/scripts/middleware/wmbprofile $i >> /dev/null
    dspmq|awk -F"[(*)]" '{print  $2}'|while read qmgr
    do
        str="$qmgr.SVR/TCP/'`hostname`(`ps -ef|grep lsr|grep $qmgr|awk '{print $15}'`)'"
        export "MQSERVER=${str}"
        for j in `echo "dis ql(*) where(curdepth gt 0)"|runmqsc $qmgr|grep 'QUEUE(' | awk -F"[(*)]" '{ print $2}' | grep ".ERROR$"`
        do
            echo "`echo export MQSERVER=$MQSERVER`;/WebSphere/wmqutil/qload -l mqic32  -I $j -f $qmgr.$j" >>  .temp.sh
        done
        for j in `echo "dis ql(*) where(curdepth gt 0)"|runmqsc $qmgr|grep 'QUEUE(' | awk -F"[(*)]" '{ print $2}' | grep ".IB$"`
        do
            echo "`echo export MQSERVER=$MQSERVER`;/WebSphere/wmqutil/qload -l mqic32  -I $j -f $qmgr.$j" >>  .temp.sh
        done
    done
done

cat .temp.sh |mail -r errqclean_noreply@cusa.canon.com -s "`hostname -a` :errqclean-sh "  q17020@cusa.canon.com
chmod +x .temp.sh
. ./.temp.sh
cd $apperrorsdir
zip -rm apperrors_$now.zip $apperrorsdir/$now
unzip -l apperrors_$now.zip |mail -r errqclean_noreply@cusa.canon.com -s "`hostname -a` :errqclean-sh "  q17020@cusa.canon.com

 