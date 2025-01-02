Content :

Exists:IIBT1BB34:Truststore:/WebSphere/wmbconfig/tst1/keystore/v10/esbtst/esbtst.jks

Output :

cat trust.ck | awk -F ":" '{print $5}' | uniq
/WebSphere/wmbconfig/tst1/keystore/v9/esbtst/esbglobaltst.jks

**SSL Commands**

1. fingerprint
keytool -list -keystore $1 -storepass $2 | grep -v fingerprint | grep -v Keystore | grep -v keystore | awk -F"," '{print $1}' | grep -v '^[[:space:]]*$' | sort > /tmp/alllbls


| S.No | Commands | Description |
| ------ | ---------- | ------------- |
| 1    |keytool -list -keystore jks -storepass pwd|
| 2    |          |             |
