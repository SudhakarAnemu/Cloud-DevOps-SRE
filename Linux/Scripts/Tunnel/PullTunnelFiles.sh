cat /home/wmbadmin/PullTunnelFiles.sh


 pscount=ps -ef|grep com.canon.usa.cdf.test.TestPubSub|grep -v grep|wc

  if [[ $pscount -eq 0 ]]; then
        echo " Process not running - Starting Tunnel"
        #nohup /home/wmbadmin/PullTunnelFiles.sh &
         /opt/ibm/mqsi/v10/iib-10.0.0.25/common/jdk/jre/bin/java  -Dfile.encoding=Cp1252 -classpath "/WebSphere/wmbconfig/prd/v9/esb/lib/112jars:/WebSphere/wmbconfig/prd/v9/esb/lib/112jars/*" -Xms1G -Xmx2G -XX:+ShowCodeDetailsInExceptionMessages com.canon.usa.cdf.test.TestPubSub
else
        echo " Tunnel Running "
  fi




