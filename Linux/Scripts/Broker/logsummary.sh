#!/bin/bash

# Input log file
LOGFILE="/var/log/wmb.log"
CLOGFILE="/tmp/wmb.log"

# Number of hours to look back
X_HOURS=6  # Change this value as needed

# Get the current timestamp in seconds since the epoch
CURRENT_TIME=$(date +%s)

# Calculate the cutoff time in seconds since the epoch
CUTOFF_TIME=$((CURRENT_TIME - X_HOURS * 3600))

# Number of lines per chunk
CHUNK_SIZE=1000  # You can adjust this depending on your system and log size

echo "Log Summary for $LOGFILE (Last $X_HOURS hours)"
echo "------------------------------------------------------------ `date` "
echo "Cutoff time (in epoch seconds): $CUTOFF_TIME"
echo "Processing in chunks of $CHUNK_SIZE lines."

# Split the log file into chunks and process each chunk
split -l $CHUNK_SIZE "$LOGFILE" "$CLOGFILE.chunk_"

# Initialize a temporary file for storing results
TEMP_FILE=$(mktemp)

# Loop through each chunk in reverse order (latest chunk first)
for CHUNK in $(ls "$CLOGFILE.chunk_"* | sort -r); do
    echo "Processing chunk: $CHUNK"

    # Check the timestamp of the first log entry in the chunk
    FIRST_TIMESTAMP=$(head -n 1 "$CHUNK" | awk '{print $1 " " $2 " " $3}')
    FIRST_TIMESTAMP_EPOCH=$(date -d "$FIRST_TIMESTAMP" +%s)

    # Process the chunk even if the first log is older than the cutoff time
    # We'll still filter out logs individually later.
    awk -v cutoff_time="$CUTOFF_TIME" '
    BEGIN {
        cutoff_epoch = cutoff_time
    }
    {
        # Extract the log timestamp (first 3 fields)
        log_timestamp = $1 " " $2 " " $3

        # Try to convert the log timestamp to epoch seconds
        cmd = "date -d \"" log_timestamp "\" +%s"
        cmd | getline log_epoch
        close(cmd)

        # If the conversion fails, skip this line
        if (log_epoch == "") {
            print "ERROR: Invalid timestamp: " log_timestamp
            next
        }

        # Only process logs from the last X hours
        if (log_epoch >= cutoff_epoch) {
            # Remove the first 6 fields and output the remaining message
            for (i=1; i<=6; i++) $i=""
            print substr($0, index($0,$7))  # Skips leading spaces
        }
    }' "$CHUNK" >> "$TEMP_FILE"
done

# Once all chunks are processed, aggregate results
echo "Aggregating results..."
cat "$TEMP_FILE" | sort | uniq -c | sort -nr

# Clean up temporary chunk files and temp file
echo "Cleaning up temporary files..."
rm -f "$CLOGFILE.chunk_"*
rm "$TEMP_FILE"

echo "Log processing complete. `date`"

