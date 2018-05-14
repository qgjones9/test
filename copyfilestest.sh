#!/bin/bash

FILE=$1

while read line; do

scp  maxon_desronvil@$line:/logs/webapps/tssfr/appTssfr.log  /home/maxon_desronvil/$line.appTssfr.log


done < $FILE

