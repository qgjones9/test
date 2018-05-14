#!/bin/bash

#  The server to be checked will be based on the user's input
#  There is no case sensitivity functionality built into the program yet
echo -e -n -E "Which COLO would you like to run this script on (wa | ma | tx):"
read COLO

#  This is the main function for the script
function memory(){

#  I want the script to tell me the hostname that the following commands 
#+ will be run on
echo "########"
hostname
echo "########"

#  This section is sort of like a dashboard read-out of the swap figures on
#+  the server
echo "Total swap found : "  $(free -h | grep Swap | fmt -u | cut -d " " -f 2)
echo "Total swap used  : "  $(free -h | grep Swap | fmt -u | cut -d " " -f 3)
echo "Swap remaining   : "  $(free -h | grep Swap | fmt -u | cut -d " " -f 4)

# I used the following like to get the total swap for the host
# I had to change the integer into a float value for the percent calculation
swapTotal=$(free  | grep Swap | fmt -u | cut -d " " -f 2)
swapTotalFloat="$(bc <<< $swapTotal*1.00)"

#  This section is getting the swap used on the host
#  I again changed the used swap integer into a float for percent calculation
swapUsed=$(free  | grep Swap | fmt -u | cut -d " " -f 3)
swapUsedFloat="$(bc <<< $swapUsed*1.00)"

#  This section is for finidng the remaining swap on the server
swapRemaining=$(free  | grep Swap | fmt -u | cut -d " " -f 4)

#  Here i set a hard constant for the percent check on the server
swapPercent="0.25"

#  Here i wanted to see what is the swap threshold according to the set 
#+ percent value
swapThreshold="$(bc <<< $swapTotalFloat*$swapPercent)"
swapThresholdInteger=$(echo $swapThreshold | cut -d "." -f 1)

#  Now is the fun part the if statements
#  So i want to see if the remaining swap on the host is below 25%
if [[ $swapRemaining -ge $(bc <<< $swapTotal-$swapThresholdInteger) ]]; then

#If the server is good on swap then perform the following actions
echo
echo "There is more than 25% of swap remaining on this host"
echo

#  Continue with if function
else

#  If the serrver is not good on swap perform the following actions
echo 
echo "Swap needs to be addressed on this host"
echo

#  Finish off the function and exit the script
fi
}

#  If the user input is ma run the following if-then-elif statement
if [[ ${COLO} == ma ]]; then

#  You can change the server listing to one or many
for i in nvmanvp22{00..11};
do
ssh -q -o StrictHostKeyChecking=no $i "
$(cat << EOT
$(typeset -f)
memory
EOT
)"
done

#  If the user input is tx run the following if-then-elif statement
elif [[ ${COLO} == tx ]];then

#  You can change the server listing to one or many
for i in nvtxnvp22{00..11};
do
ssh -q -o StrictHostKeyChecking=no $i "
$(cat << EOT
$(typeset -f)
memory
EOT
)"
done

#  If the user input is wa run the following if-then-elif statement
elif [[ ${COLO} == wa ]];then

#  You can change the server listing to one or many
for i in nvwanvp22{00..11};
do
ssh -q -o StrictHostKeyChecking=no $i "
$(cat << EOT
$(typeset -f)
memory
EOT
)"
done


fi
