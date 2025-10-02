
#js

#!/bin/bash
#/WebSphere/scripts/middleware/ace/jksExistsJvmHttpsAllBrkrs.sh tag1 tag2 tag3
#for i in 7 9 10
for ver in 7 9 10 12
do
      . /WebSphere/scripts/middleware/wmbprofile $ver >> /dev/null
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
            echo "---------------------------------------Version : $ver ---------- I am checking for $brk-------"   
            /WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk $1 $2
      done
done

# Its for brokers for a specific version. 
#!/bin/bash
#/tmp/jsmq/js.sh tag1 tag2 tag3
      for brk in `mqsilist|grep BIP1284I|awk -F"'"  '{print $2}'`
      do
            echo "---------------------------------------Version : $ver ---------- I am checking for $brk-------"   
            /WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk $1 $2
      done


