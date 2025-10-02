#js
#Example :
# /WebSphere/scripts/middleware/ace/Cpmr2FJrs.sh folder1 folder2

#Declaring variables
fldr1=$1
fldr2=$2
file1=/tmp/file1
file2=/tmp/file2
ffile
sfile
rm -rf $file1 $file2
echo -e "\nGiven Folder 1 : --$fldr1--, Folder 2 : --$fldr2--"

# Populate jar files of folder1
SNO=1
while IFS= read -r -d $'\0' jar_file; do
    echo -e "\nName ($SNO): --$jar_file--"
    file_name=$(basename "$jar_file")
    file_size=$(stat -c %s "$jar_file") # Use %s for size in bytes
    echo -e "$file_name:$file_size" >> $file1
    ((SNO=SNO+1))
done < <(find "$fldr1" -type f -name "*.jar" -print0)

echo -e "\nContents in file 1 : "
cat -n $file1

# Populate jar files of folder2
SNO=1
while IFS= read -r -d $'\0' jar_file; do
    echo -e "\nName ($SNO): --$jar_file--"
    file_name=$(basename "$jar_file")
    file_size=$(stat -c %s "$jar_file") # Use %s for size in bytes    
    echo -e "$file_name:$file_size" >> $file2
    ((SNO=SNO+1))
done < <(find "$fldr2" -type f -name "*.jar" -print0)

echo -e "\nContents in file 2 : "
cat -n $file2

#Compare two files based on the Size : 
# Get sizes in bytes
size1=$(stat -c %s "$file1")
size2=$(stat -c %s "$file2")
echo -e "\nSize of File 1: $file1 (Size: $size1 bytes)"
echo -e "\nSize of File 2: $file2 (Size: $size2 bytes)"
if [ "$size1" -gt "$size2" ]; then
    echo "'$file1' is larger than '$file2'."
    ffile=$file1
    sfile=$file2
elif [ "$size2" -gt "$size1" ]; then
    echo "'$file2' is larger than '$file1'."
    ffile=$file2
    sfile=$file1
else
    echo "Both '$file1' and '$file2' have the same size."
    ffile=$file1
    sfile=$file2   
fi

echo -e "\nLets Compare $ffile with $sfile"





---------------------------------------------> Ex - codes 

/WebSphere/scripts/middleware/ace/Cpmr2FJrs.sh /tmp/jsmq/fold1 /tmp/jsmq/fold2

folder1 = /tmp/jsmq/fold1
folder2 = /tmp/jsmq/fold2
folder3 = /tmp/jsmq/fold3

mkdir -p /tmp/jsmq/fold1 /tmp/jsmq/fold2 /tmp/jsmq/fold3

VM[wmbadmin@varhdv122 fold1] ls -rlt
total 424
-rw-r--r-- 1 wmbadmin mqm  99989 Jul 29 08:47 two.jar
-rw-r--r-- 1 wmbadmin mqm 267617 Jul 29 08:47 three.jar
-rw-r--r-- 1 wmbadmin mqm  59771 Jul 29 08:47 one.jar
VM[wmbadmin@varhdv122 fold1] pwd
/tmp/jsmq/fold1
VM[wmbadmin@varhdv122 fold1]


