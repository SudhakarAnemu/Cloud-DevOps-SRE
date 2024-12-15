#js
# Check file1(ciphers) exists on Full list ciphers.

#/WebSphere/scripts/middleware/check_lines.sh
#!/bin/bash
# Check if two filenames are provided as arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: check_lines file1 file2"
    exit 1
fi

file1="$1" #wmbtrust ciphers
file2="$2" #Needs to check this

# Check if both files exist
if [[ ! -f "$file1" || ! -f "$file2" ]]; then
    echo "Error: One or both files do not exist."
    exit 1
fi

# Read lines from file1 into an array
lines1=($(cat "$file1"))

# Iterate over lines in file2
while IFS= read -r line2;
do
    # Check if the line from file2 exists in the array from file1
    if [[ " ${lines1[*]} " =~ " $line2 " ]]; then
        echo "$line2 exists in both files."
    else
        echo "$line2 does not exist in file1."
    fi
done < "$file2"
