Melville_RHEL8[wmbadmin@varhdv117 jsmq] cat /WebSphere/scripts/middleware/canonID_pgp.sh
#echo "login ID : `id`"
PATH=$PATH:/usr/bin/gpg
export $PATH
injLocation=/WebSphere/s21iblocal/dev/canonID/input/json
ingpgLocation=/WebSphere/s21iblocal/dev/canonID/input/gpg
outjLocation=/WebSphere/s21iblocal/dev/canonID/output/json
outgpgLocation=/WebSphere/s21iblocal/dev/canonID/output/gpg

if [ $# -ne 1 ]; then
  echo "Usage: $0 <encrypt|decrypt>"
  exit 1
fi

if [[ $1 == "encrypt" ]];
then
        echo 'asdfsd@@@@ wrETr9=H   @@@@@@@ asdfsd '
        cd $injLocation
        sftp   iDam@ftpconnect.cusa.canon.com  << EOF
                cd outbound
                mget *.json
                rm *.json
                bye
EOF

        #cd $ingpgLocation
        cd $injLocation
        for i in `ls -1 $injLocation/*.json`
         do
                outfile="`basename $i`.gpg"
        #       gpg --output $outfile --encrypt --recipient "S21_INTEGRATION_WMBADM61_VASUDV37 <s21_integration_team@cusa.canon.com>" $i
                gpg --output $outfile --encrypt --recipient "IDM_Migration <dev.ccbidm.test@gmail.com>" $i
                gpg --enarmor $outfile
                #mv $outfile".asc" $ingpgLocation/$outfile
                if [[ $? -eq 0 ]]; then
                   mv $outfile".asc" $ingpgLocation/$outfile
                   mv $i  $injLocation/mqsiarchive
                else
                  echo "!!!! Error - cannot encrypt file $i"
                fi
        done
        rm -f $injLocation/*.gpg
        #mv $injLocation/*.json $injLocation/mqsiarchive
        #echo 'asdfsd@@@@ wrETr9=H   @@@@@@@ asdfsd '
        #rm -f /WebSphere/s21iblocal/dev/canonID/*json
elif [[  $1 == "decrypt" ]];
then
        #echo "in Decrypt"
        #cd $outjLocation
        #cd $outgpgLocation
        #for i in `ls -1 *.gpg`
        #do
        #       gpg --dearmor $i
        #       mv $i".gpg" $i
        #done
        #for i in `ls -1 *.gpg`
        # do
                #outfile=`basename $i .gpg`
                #echo $outfile
                #gpg --decrypt -o $outfile  $i
                #if [[ $? -eq 0 ]]; then
                #       echo "decrypted file $outjLocation/$outfile"
                #        mv $outfile $outjLocation
                #        mv $outgpgLocation/$i $outgpgLocation/mqsiarchive
                #else
                #        echo "!!!! Error - cannot decrypt file $i"
                #fi
        #done
        cd $outjLocation
        cp -p $outjLocation/* $outjLocation/mqsiarchive/
        echo 'asdfsd@@@@ wrETr9=H   @@@@@@@ asdfsd '
        sftp   iDam@ftpconnect.cusa.canon.com  << EOF
                cd inbound
                mput *
                bye

EOF
rm -f $outjLocation/*
else
        echo " **********  Wrong option : $1 --->  Usage: $0 <encrypt|decrypt>"
fi
Melville_RHEL8[wmbadmin@varhdv117 jsmq]
