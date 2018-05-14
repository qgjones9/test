#!/bin/bash
## Script to push .ssh pub key to multiple servers
##Written by Jason Hatfield @ NOC - 10/5/2016
###################################################

##Initial Variables and Info gathering


##Gather user information

#Verify that script is not being run as root
if [ "${USER}" == "root" ];then 
	echo "Cannot run script as root, exiting"
	sleep 2
	exit 0
fi

#Verify User Name
echo "I see your username is ${USER}";
echo "Is that correct?  yes/no"
 read ANSWER
	if [ "${ANSWER}" == "yes" ]; then
	USERNAME=${USER}; echo "Thanks, proceeding with user as ${USERNAME}"
	else
		echo "Please login as the correct user and rerun this script."
		sleep 2
		exit 0
	fi 

##Check that user ssh-key exists
echo "Checking that your user has a .pub key on this host"
[ -f "/home/${USERNAME}/.ssh/id_rsa.pub" ]
	if [ $? -ne "0" ]; then 
		echo "Unable to locate ${USERNAME}'s id_rsa.pub, exiting"; sleep 2; exit 0
	else	
		echo "Found id_rsa.pub for ${USERNAME}, proceeding"
	fi
sleep 1
echo "      ######################    "
##Gather password information 
echo "Please enter your password";
 read -s PASSWORD
	echo "Please enter your password again"
	  read -s PWDTWO
		if [[ "${PASSWORD}" == "${PWDTWO}" ]]; then
			echo "Passwords match, proceeding"
		else
			echo "Passwords do not match. Lets try again.  Please enter your password"
			  read -s PWDTHREE
				if [[ "${PASSWORD}" == "${PWDTHREE}" ]]; then
					echo "Passwords match, proceeding"
				else
					echo "Passwords do not match, time to say goodbye"; sleep 1; exit 0
				fi
		fi		
sleep 1
echo "      ######################    "
##Gather file name and location
echo "Please enter complete path to Server List file";
 read FILEPATH
##Check that file path and file exist
[ -f "${FILEPATH}" ]
   if [ $? -ne "0" ]
	then echo "Provided filepath was incorrect, please try again"
	read FILEPATH
		[ -f "${FILEPATH}" ]
			if [ $? -ne "0" ]; then
			echo "Provided filepath was incorrect again, exiting";
			exit 0
			fi
   fi
## Sleep for a second and then slear screen
sleep 1
clear
##More Variables
SERVERCHECK="0"
SSHTEST="0"
DATE=`date +%F`
FAILEDLOG=/home/${USERNAME}/failedkeys${DATE}_${RANDOM}.txt
SUCCESSLOG=$(mktemp)
trap "rm -f ${SUCCESSLOG}" EXIT
touch ${FAILEDLOG}

#####################################################
#Begin functions
#####################################################

#Check if server is in known hosts  
check_server()
{
echo "Checking ${SERVER} in known hosts file"
grep ${SERVER} /home/${USERNAME}/.ssh/known_hosts > /dev/null
	if [ $? -ne "0" ]; then
		SERVERCHECK="1" && echo "${SERVER} Not found in known hosts"
	else
		echo "${SERVER} found, proceeding to test ssh"
	fi
}
######################################################

#Test if login is successful with key  
test_ssh()
{
echo "Testing for login success"
ssh -q -o PasswordAuthentication=no -o ConnectTimeout=4 ${USERNAME}@${SERVER} exit
	if [ $? -ne "0" ]; then
		SSHTEST=1 && echo "Login Failed"
	else  
		SSHTEST=0 && echo "Login successful"
	fi
}

######################################################
#Test for key on server that is NOT in known hosts
known_host_enter()
{
/usr/bin/expect<< EOF
#!/usr/bin/expect -f
set timeout 5
spawn ssh -o PasswordAuthentication=no -o ConnectTimeout=4 ${USERNAME}@${SERVER} exit
match_max 100000
expect -exact "The authenticity of host '${SERVER}*' can't be established.\r
RSA key fingerprint is *.\r
Are you sure you want to continue connecting (yes/no)? "
send -- "yes\r"
expect eof
EOF
}

######################################################
#Key Push for server that is in known hosts
known_ssh()
{
/usr/bin/expect<< EOF
#!/usr/bin/expect -f
set timeout 5
spawn ssh-copy-id $SERVER
match_max 100000
expect -exact "$USERNAME@$SERVER's password: "
send -- "$PASSWORD\r"
expect eof
EOF
}

######################################################
##Begin Key Push
trap "exit" INT 
for SERVER in `cat ${FILEPATH}`
	do 
	check_server
		if [ ${SERVERCHECK} -eq "0" ]; then 
			test_ssh
			if [ ${SSHTEST} -eq "0" ]; then
				echo "Looks like your key is already deployed to ${SERVER}";
			else
				known_ssh
					if [ $? -eq "0" ]; then
					test_ssh
						if [ ${SSHTEST} -eq "0" ]; then
							echo " --- ${SERVER} login confirmed! High Fives all around! --- " && echo ${SERVER} >> ${SUCCESSLOG}
						else		
							echo " --- ${SERVER} is sad, Login Failed --- " && echo ${SERVER} >> ${FAILEDLOG}
						fi
					fi
			fi
		else
			known_host_enter
			test_ssh
                        if [ ${SSHTEST} -eq "0" ]; then
                                echo "Looks like your key is already deployed to ${SERVER}";
			else
				IP=`host $SERVER  | awk '{ print $4}'`
				known_ssh
				if [ $? -eq "0" ]; then
					test_ssh
						if [ ${SSHTEST} -eq "0" ]; then
							echo " --- ${SERVER} login confirmed! High Fives all around! --- " && echo ${SERVER} >> ${SUCCESSLOG}
						else		
							echo " --- ${SERVER} is sad, Login Failed --- " && echo ${SERVER} >> ${FAILEDLOG}
						fi
				fi
			fi
		fi
echo "      ######################    "
	done									
######################################################				
## Completion Results
SUCCESSCOUNT=`cat ${SUCCESSLOG} | wc -l`
FAILEDCOUNT=`cat ${FAILEDLOG} | wc -l`
TOTALCOUNT=`cat ${FILEPATH} | wc -l`

echo " -----  There were ${SUCCESSCOUNT} successful key transfers and ${FAILEDCOUNT} failed key transfers out of ${TOTALCOUNT} total ----- " 	
	if [ ${FAILEDCOUNT} -gt 100 ]; then
		echo "{$FAILEDCOUNT} is a lot 'o' failures, much improve must I"
	fi
######################################################
## Cleanup
find /home/${USERNAME} -maxdepth 1 -mtime +7 -type f -name "failedkeys*" -exec rm {} \;

