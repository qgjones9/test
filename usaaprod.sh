#!/bin/bash


declare -a arr=( "nvmaspt052" "nvwaspt052" "nvtxspt052" )

for i in ${arr[@]}
do ssh -q $i "$(cat << EOT

sudo systemctl status UDRScheduler
cd /opt/psusaa/usaa_udrlog_1_0_0/UDRLog
sudo systemctl stop UDRScheduler
sudo ./lms_pass.sh
sudo systemctl start UDRScheduler
sudo systemctl status RDRScheduler
cd /opt/psusaa/usaa_rdrlog_1_0_0/RDRLog
sudo systemctl stop RDRScheduler
sudo ./lms_pass.sh
sudo systemctl start RDRScheduler

EOT
)";  done
