#!/bin/bash

# Set the path to the keystore file
KEYSTORE_FILE="/path/to/your/keystore.jks"

# Set the keystore password
KEYSTORE_PASSWORD="your_keystore_password"

# Function to check certificate expiration
check_certificate_expiration() {
  local alias="$1"
  keytool -list -v -keystore "$KEYSTORE_FILE" -storepass "$KEYSTORE_PASSWORD" -alias "$alias" 2>/dev/null | \
    awk '/Valid from:/ { from=$0; } /Valid until:/ { until=$0; } END { if (from && until) { print "Alias: " alias; print from; print until; } }' | \
    awk '{ if ($0 ~ /Valid until:/ && $0 !~ /after indefinitely/) { print "Certificate for alias " alias " expires on " $4; } }'
}

# Get a list of all aliases in the keystore
aliases=$(keytool -list -v -keystore "$KEYSTORE_FILE" -storepass "$KEYSTORE_PASSWORD" | awk '/Alias/ { print $2 }')

# Loop through each alias and check for expiration
for alias in $aliases; do
  check_certificate_expiration "$alias"
done

