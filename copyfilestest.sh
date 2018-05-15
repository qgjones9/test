#!/bin/bash

FILE=$1

while read line; do

scp  $user@$line:/logs/webapps/tssfr/appTssfr.log  /home/$user/$line.appTssfr.log


done < $FILE

