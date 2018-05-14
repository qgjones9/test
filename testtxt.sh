#!/bin/bash

FILE=$1

while read line; do

ssh -q  $line << EOF

hostname

EOF

done < $FILE
