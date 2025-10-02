#js 
#zipjsonpgp.sh
#/WebSphere/scripts/middleware/zipjsonpgp.sh
#!/bin/bash
now=$(date +"%m%d%Y-%H%M")
LOG=/tmp/log.log
>$LOG
# Define an array with your folder paths
folder_paths=(
    "/WebSphere/s21iblocal/dev/canonID/output/json/mqsiarchive"
    "/WebSphere/s21iblocal/dev/canonID/input/gpg/mqsiarchive"
    "/WebSphere/s21iblocal/dev/canonID/input/json/mqsiarchive"
)

# Loop through the array and print each path
for path in "${folder_paths[@]}"; do
    #echo "Folder Path: --$path--"
    cd $path
    echo -e "\nExecuting at Date : $now ------------------------------ Folder : $path" >> $LOG
    echo -e "\nNumber of json files before Zip"  >> $LOG
    ls -lrt $path/*json* | wc -l  >> $LOG
    zip -m $now.zip *json* >> $LOG
    echo -e "\nNumber of json files after Zip"  >> $LOG
    ls -lrt $path/*json* | wc -l  >> $LOG
    echo -e "\nList of zip files"  >> $LOG
    ls -lrt $path/*.zip     >> $LOG
done
echo -e "\n DSpace of WebSphere-----------------------------------" >> $LOG
df -h | grep -i websphere >> $LOG
cat $LOG | mail -r zipjsonpgp_noreply@cusa.canon.com -s "`hostname -a` :zipjsonpgpFiles"  q17020@cusa.canon.com

#Cron to run for every hour
#0 * * * * scrpt
#0 * * * * /WebSphere/scripts/middleware/zipjsonpgp.sh >/dev/null 2>&1