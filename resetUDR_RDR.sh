#!/bin bash

declare -a scriptingServer=( "nvmaspt053" "nvtxspt053" "nvwaspt053" )


echo -e -E -n "Please enter the LMS password to encrypt: "
read password
echo $password

function passUDR(){
hostname
service UDRScheduler stop
PASS=`java -classpath lib/commons-codec-1.3.jar:lib/rdr-generator.jar com.nuance.usaa.lms.utilities.RSAEncryptor udr_rsa_public.key $password`
sed -ri "s,(LMS\.password=).*$,\1$PASS," /opt/psusaa/usaa_udrlog_1_0_0/UDRLog/config.properties
chkconfig --levels 345 RDRScheduler off
}

function passRDR(){
hostname
service UDRScheduler stop
PASS=`java -classpath lib/commons-codec-1.3.jar:lib/rdr-generator.jar com.nuance.usaa.lms.utilities.RSAEncryptor udr_rsa_public.key $password`
sed -ri "s,(LMS\.password=).*$,\1$PASS," /opt/psusaa/usaa_rdrlog_1_0_0/RDRLogconfig.properties
chkconfig --levels 345 RDRScheduler off
}

for i in ${scriptingServer[@]}
do
ssh -q $i "
$(typeset -f)
passUDR
passRDR
"
done

