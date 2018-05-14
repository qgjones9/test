#!/bin/bash


declare -a arr=( "nvmaspt053" "nvwaspt053" "nvtxspt053" )

for i in ${arr[@]} 
do ssh -q $i "$(cat << EOT

sudo systemctl status UDRScheduler 
cd /opt/psusaa/usaa_udrlog_1_0_0/UDRLog
sudo systemctl stop UDRScheduler  
sudo ./lms_pass.sh
sudo chkconfig --levels 345 UDRScheduler off
sudo systemctl status RDRScheduler
cd /opt/psusaa/usaa_rdrlog_1_0_0/RDRLog
sudo systemctl stop RDRScheduler
sudo ./lms_pass.sh
sudo chkconfig --levels 345 RDRScheduler off

EOT
)";  done 
