#!/bin/bash


#Create the function you would like to be run remotely
function f1(){
#insert all of your commands here for this function
hostname
}

#ssh into the remote server
ssh -q -o StrictHostKeyChecking=no nvmanvp1600 "
### use a here document to enter commands on the remote host's CLI
$(cat << EOT
#### typeset -f allows the \functions in the script to be run remotely
$(typeset -f) 
#### call the f1 function now to see if hostname is returned
f1
### EOT is the ending delimiter for the hell file
EOT
)"
