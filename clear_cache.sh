#!/bin/bash

set -x 
#set -n

for i in $(echo {00..58})
do
ssh -q -o StrictHostKeyChecking=no nvmanvp11$i "
$(cat << EOT
sudo systemctl status squid 
sudo systemctl stop squid
sudo /usr/bin/rm -rf /var/spool/squid/
sudo mkdir /var/spool/squid/
sudo chown squid:squid /var/spool/squid/
sudo chmod 750 /var/spool/squid/
sudo  systemctl start squid 
sudo /opt/wells/preload_squid.sh
sudo systemctl status squid
EOT
)"
done  
