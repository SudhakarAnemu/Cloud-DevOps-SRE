
#js
#!/bin/bash
#/WebSphere/scripts/middleware/jksexistsHttps.sh
brk=$1
BrkKeyStFile=`mqsireportproperties $brk -o BrokerRegistry -n brokerKeystoreFile | grep -v BIP8071I | tr -d '\n'`
#echo -e "BrkKeyStFile - $BrkKeyStFile"
    if ! [[ -f $BrkKeyStFile ]]; then
        echo -e "Not exists-Brk-File : $BrkKeyStFile"
    else
        echo -e "Exists-Brk-File : $BrkKeyStFile"
    fi
BrkTrustFile=`mqsireportproperties $brk -o BrokerRegistry -n brokerTruststoreFile | grep -v BIP8071I | tr -d '\n'`
#echo -e "BrkTrustFile - $BrkTrustFile"
    if ! [[ -f $BrkTrustFile ]]; then
        echo -e "Not exists-Brk-File : $BrkTrustFile"
    else
        echo -e "Exists-Brk-File : $BrkTrustFile"
    fi
for i in `mqsilist $brk|grep BIP1286I|awk -F"'" '{print $2}' | sort -n`;   do
    #echo -e "HTTPSConnector for EG : $i"
    CkeystoreFile=`mqsireportproperties  $brk -e $i -o HTTPSConnector -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not exists-EG:https : $i : $CkeystoreFile-Keystore"
    else
        echo -e "Exists-EG:https : $i : $CkeystoreFile-Keystore"
    fi
    CTrustFile=`mqsireportproperties  $brk -e $i -o HTTPSConnector -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not exists-EG:https : $i : $CTrustFile-Truststore"
    else
        echo -e "Exists-EG:https : $i : $CTrustFile-Truststore"
    fi

    #echo -e "ComIbmJVMManager for EG : $i"
    CkeystoreFile=`mqsireportproperties  $brk -e $i -o ComIbmJVMManager -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not exists-EG:jvm : $i : $CkeystoreFile-Keystore"
    else
        echo -e "Exists-EG:jvm : $i : $CkeystoreFile-Keystore"
    fi    
    CTrustFile=`mqsireportproperties  $brk -e $i -o ComIbmJVMManager -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    #echo -e "CkeystoreFile - $CkeystoreFile"
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not exists-EG:jvm : $i : $CTrustFile-Truststore"
    else
        echo -e "Exists-EG:jvm : $i : $CTrustFile-Truststore"
    fi






done

