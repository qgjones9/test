
#!/bin/bash

FILE=$1

while read line; do

ssh -q  $line << EOF

hostname
cd /var/spool
sudo systemctl stop squid
sudo rm -rf squid
sudo mkdir squid
sudo chown squid:squid squid
sudo squid -z
sudo ls -alrt squid
sudo systemctl start squid
sudo /etc/init.d/nuance-wd restart 
EOF

done < $FILE
