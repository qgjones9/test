#!/bin/bash
set -x
## This script will copy a user's existing id_rsa.pub file's contents
## to the user's destination $HOME/.ssh/authorized_keys file.

function usage()
{
cat << EOF
USAGE: $0 [OPTIONS ...]

NOTE:

OPTIONS:
    -H <HOSTNAME>
EOF
}

USERNAME=$(/usr/bin/whoami)
USERID=$(/usr/bin/id -u)
ROOTHOMEDIR="/root"
USERHOMEDIR="/home/$USERNAME"

if [[ $USERID -eq 0 ]] 
then
    if [[ $# -gt 0 ]]
    then
        while getopts ":H:" OPTION
        do
            case $OPTION in
            H)
                cat $ROOTHOMEDIR/.ssh/id_rsa.pub|/usr/bin/ssh -q -o StrictHostKeyChecking=no -p22 $USERNAME@$2 "(if [[ -e $ROOTHOMEDIR/.ssh ]];then cat >> $ROOTHOMEDIR/.ssh/authorized_keys;else mkdir $ROOTHOMEDIR/.ssh;cat >> $ROOTHOMEDIR/.ssh/authorized_keys;/sbin/restorecon -R -v $ROOTHOMEDIR/.ssh;chmod 700 $ROOTHOMEDIR/.ssh;chmod 700 .ssh/authorized_keys;fi)"
                exit 0
            ;;
            *)
                usage
                exit
            ;;
            esac
        done
    else
        usage
    fi
else
    if [[ $# -gt 0 ]]
    then
        while getopts ":H:" OPTION
        do
            case $OPTION in
            H)
                cat $USERHOMEDIR/.ssh/id_rsa.pub|/usr/bin/ssh -v -q -o StrictHostKeyChecking=no -p22 $USERNAME@$2 "(if [[ -e $USERHOMEDIR/.ssh ]];then cat >> $USERHOMEDIR/.ssh/authorized_keys;else mkdir $USERHOMEDIR/.ssh;cat >> $USERHOMEDIR/.ssh/authorized_keys;/sbin/restorecon -R -v $USERHOMEDIR/.ssh;chmod 700 $USERHOMEDIR/.ssh;chmod 700 .ssh/authorized_keys;fi)"
                     exit 0
            ;;
            *)
                usage
                exit
            ;;
            esac
        done
    else
        usage
    fi
fi 
