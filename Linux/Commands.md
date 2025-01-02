Content :

Exists:IIBT1BB34:Truststore:/WebSphere/wmbconfig/tst1/keystore/v10/esbtst/esbtst.jks

Output :

cat trust.ck | awk -F ":" '{print $5}' | uniq
/WebSphere/wmbconfig/tst1/keystore/v9/esbtst/esbglobaltst.jks

**SSL Commands**

| S.No | Commands | Description |
| ------ | ---------- | ------------- |
| 1    |keytool -list -keystore jks -storepass pwd|
| 2    |          |             |
