# js 

#js
#!/bin/bash
#/WebSphere/scripts/middleware/ALLDtilsByEG.sh
brk=$1
eg=$2
echo -e "---------------------------- JKS - https and jvm of the $brk - $eg"

    #echo -e "HTTPSConnector for EG : $eg"
    CkeystoreFile=`mqsireportproperties  $brk -e $eg -o HTTPSConnector -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not-Exists:https:$eg:Keystore:$CkeystoreFile"
    else
        echo -e "Exists:https:$eg:Keystore:$CkeystoreFile"
    fi
    CTrustFile=`mqsireportproperties  $brk -e $eg -o HTTPSConnector -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not-Exists:https:$eg:Truststore:$CTrustFile"
    else
        echo -e "Exists:https:$eg:Truststore:$CTrustFile"
    fi

    #echo -e "ComIbmJVMManager for EG : $eg"
    CkeystoreFile=`mqsireportproperties  $brk -e $eg -o ComIbmJVMManager -n keystoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CkeystoreFile ]]; then
        echo -e "Not-Exists:jvm:$eg:Keystore:$CkeystoreFile"
    else
        echo -e "Exists:jvm:$eg:Keystore:$CkeystoreFile"
    fi  
    CTrustFile=`mqsireportproperties  $brk -e $eg -o ComIbmJVMManager -n truststoreFile|grep -v BIP8071I|tr -d '\n'`
    if ! [[ -f $CTrustFile ]]; then
        echo -e "Not-Exists:jvm:$eg:Truststore:$CTrustFile"
    else
        echo -e "Exists:jvm:$eg:Truststore:$CTrustFile"
    fi
 
 echo -e "---------------------------- JKS - https and jvm of the $brk - $eg"
