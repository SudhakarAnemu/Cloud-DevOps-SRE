#JS 
#/WebSphere/scripts/middleware/ace/chkJksV10V9ToACE.sh brk
#!/bin/bash

brk=$1
LOG=jksJvmHttps.$brk

/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh $brk 1 2

echo -e "\nFull list of Jks : "
cat -n jksJvmHttps.$brk.2.1

echo -e "\nFull list of Jks (exists) : "
cat jksJvmHttps.$brk.2.1 | grep -v "Not-Exists" 
echo -e "\nList out the Jks (exists) : "
cat jksJvmHttps.$brk.2.1 | grep -v "Not-Exists" | awk -F":" '{print $5}' > /tmp/del
SNO=1
while IFS= read -r line
do
   echo -e "----- S.No : $SNO -- $line"
   ls -l $line
   ((SNO=SNO+1))
done < /tmp/del

echo -e "\nList same file at ACE folder : "
cat jksJvmHttps.$brk.2.1 | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g'

echo -e "\nCheck same file at ACE folder : "
cat jksJvmHttps.$brk.2.1 | grep -v "Not-Exists" | awk -F":" '{print $5}' | sed 's/v9/ace/g' | sed 's/v10/ace/g' > /tmp/del
SNO=1
while IFS= read -r line
do
   echo -e "----- S.No : $SNO -- $line"
   ls -l $line
   ((SNO=SNO+1))
done < /tmp/del

echo "--------------------------------------- Completed ---------------------------------------"