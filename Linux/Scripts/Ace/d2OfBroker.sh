#JS 

#/WebSphere/scripts/middleware/ace/d2OfBroker.sh

#!/bin/bash

rm -f temp.out eglist.out esb_eglist_final.out
brk=$1
echo -e "\n---- Name of the Broker = $brk"

echo " 'BROKER' '$brk'" >> temp.out
mqsilist $brk -r -d2 |egrep '^BIP|Deployed|VERSION'|grep -v BIP8071I >> temp.out

   tac temp.out|awk -F"'" '{
   if ($1 ~ "BIP*") print "|"$4"|"$2;
     else if ($1 ~ "Deployed") printf "|"$2"|"$4;
     else if ($2 ~ "VERSION") printf $4 ;
     else if ($2 ~ "BROKER") printf $4 ;
     }' >> eglist.out
     tac eglist.out > esb_eglist_final.out

cp esb_eglist_final.out $brk.d2_final.out

#
#rm -f temp.out eglist.out esb_eglist_final.out
#for i in `mqsilist|grep -v BIP8071I|awk -F"'" '{print $2}'`
# do
#   echo " 'BROKER' '$i'" >> temp.out
#   mqsilist $i -r -d2 |egrep '^BIP|Deployed|VERSION'|grep -v BIP8071I >> temp.out
#done;
#   tac temp.out|awk -F"'" '{
#   if ($1 ~ "BIP*") print "|"$4"|"$2;
#     else if ($1 ~ "Deployed") printf "|"$2"|"$4;
#     else if ($2 ~ "VERSION") printf $4 ;
#     else if ($2 ~ "BROKER") printf $4 ;
#     }' >> eglist.out
#     tac eglist.out > esb_eglist_final.out
