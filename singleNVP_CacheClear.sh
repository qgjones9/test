#!/bin/bash

echo -e -n "What server do you want to clear squid cache? :"
read server

if [[ ${server} == *nvp* ]]
then
ssh -q -o StrictHostKeyChecking=no "${server}" "
$(cat << EOT
hostname
EOT
)"
else
echo  "This is not a correct server name #sadface"
fi
