#!/bin/bash

set -x
#set -n


echo -e -n "what server do you want to clear squid cache?"
read server

if [[ ${server} == "nv**nvp****" ]]
then
do
ssh -q -o StrictHostKeyChecking=no $server "
$(cat << EOT
sudo systemctl status squid
sudo systemctl stop squid
sudo /usr/bin/rm -rf /var/spool/squid/
sudo mkdir /var/spool/squid/
sudo chown squid:squid /var/spool/squid/
sudo chmod 750 /var/spool/squid/
sudo  systemctl start squid
sudo systemctl status squid
EOT
)"
done
else
echo  "this is not a correct server name"
fi
