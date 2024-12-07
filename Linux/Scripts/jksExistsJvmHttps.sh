
#js
#!/bin/bash
#/WebSphere/scripts/middleware/ace/jksExistsJvmHttps.sh
brk=$1
fno=$2
tag=$3
LOG=jksJvmHttps.$brk.$tag.$fno
>$LOG
BrkKeyStFile=`mqsireportproperties $brk -o BrokerRegistry -n brokerKeystoreFile | grep -v BIP8071I | tr -d '\n'`
    if ! [[ -f $BrkKeyStFile ]]; then
        echo -e "Not-Exists:$brk:Keystore:$BrkKeyStFile" >> $LOG
    else
        echo -e "Exists:$brk:Keystore$BrkKeyStFile" >> $LOG
    fi
BrkTrustFile=`mqsireportproperties $brk -o BrokerRegistry -n brokerTruststoreFile | grep -v BIP8071I | tr -d '\n'`
    if ! [[ -f $BrkTrustFile ]]; then
        echo -e "Not-Exists:$brk:Truststore:$BrkTrustFile" >> $LOG
    else
        echo -e "Exists:$brk:Truststore:$BrkTrustFile" >> $LOG
    fi
for i in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n`;   do
    CkeystoreFile=`mqsireportproperties  $brk -e $i -o HTTPSConnector -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not-Exists:https:$i:Keystore:$CkeystoreFile" >> $LOG
    else
        echo -e "Exists:https:$i:Keystore:$CkeystoreFile" >> $LOG
    fi
    CTrustFile=`mqsireportproperties  $brk -e $i -o HTTPSConnector -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not-Exists:https:$i:Truststore:$CTrustFile" >> $LOG
    else
        echo -e "Exists:https:$i:Truststore:$CTrustFile" >> $LOG
    fi

    #echo -e "ComIbmJVMManager for EG : $i"
    CkeystoreFile=`mqsireportproperties  $brk -e $i -o ComIbmJVMManager -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not-Exists:jvm:$i:Keystore:$CkeystoreFile" >> $LOG
    else
        echo -e "Exists:jvm:$i:Keystore:$CkeystoreFile" >> $LOG
    fi  
    CTrustFile=`mqsireportproperties  $brk -e $i -o ComIbmJVMManager -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not-Exists:jvm:$i:Truststore:$CTrustFile" >> $LOG
    else
        echo -e "Exists:jvm:$i::Truststore:$CTrustFile" >> $LOG
    fi
done

