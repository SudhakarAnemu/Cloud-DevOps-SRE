
/WebSphere/scripts/middleware/checkTunnel.sh


count=`find /WebSphere/s21iblocal/prd/v9/esb/cusa/cdf/mqsiarchive  -maxdepth 1  -type f -mmin -60  -ls|wc -l`
echo -n "File Count in 60 mins : $count - "
if [[ $count -eq 0 ]]; then
        echo "Tunnel did not process any messages in last 1 Hour"
        #. /WebSphere/scripts/middleware/wmbprofile 9
        #mqsireload IIBQAAA34 -e esb_cdf_pubsub
        pid=`ps -ef|grep com.canon.usa.cdf.test.TestPubSub|grep -v grep|awk '{print $2}'`
        kill -9 $pid
        nohup /home/wmbadmin/PullTunnelFiles.sh &

        #echo "`date` No Tunnel activity from the past 60 Minutes restarted Java process  `hostname` " |mail -r "noreply-MQMON@cusa.canon.com" -s " Prod : No Tunnel activity on `hostname`- Restarted Java process " q08275@cusa.canon.com,q08600@cusa.canon.com,q13761@cusa.canon.com,q17020@cusa.canon.com,q13840@cusa.canon.com
else
         #echo "Tunnel  processed messages in  !! "
        pid=`ps -ef|grep com.canon.usa.cdf.test.TestPubSub|grep -v grep|awk '{print $2}'`
        if [[ $pid -eq '' ]]; then
                echo " Tunnel is !!!NOT running !!"
        else
                echo "Tunnel is working fine :-) "
        fi

fi
sleep 5
pid=`ps -ef|grep com.canon.usa.cdf.test.TestPubSub|grep -v grep|awk '{print $2}'`
if [[ $pid -eq '' ]]; then
        echo " Tunnel is !!!NOT running !! even after restart "
        echo "`date` Tunnel is not running - even after  restarted Java process :  `hostname` " |mail -r "PleaseLookAtMe@cusa.canon.com" -s " Prod : Tunnel on `hostname`-  not running even after Restarted Java process , please look into it " q08275@cusa.canon.com,q08600@cusa.canon.com,q13761@cusa.canon.com,q17020@cusa.canon.com,q13840@cusa.canon.com

fi

