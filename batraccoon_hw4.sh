#!/bin/bash - 
#===============================================================================
#
#          FILE: getopts.sh
# 
#         USAGE: ./getopts.sh 
# 
#   DESCRIPTION: 
# 
#        AUTHOR: Matthew Smith, Jeremy Marcusen, Alex Cragun, matthewsmith4@mail.weber.edu
#  ORGANIZATION: 
#       CREATED: 10/15/2016 16:05
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#using getopts take the follwing input parameters

usage="usage: [-y year] [-e email] [-u user] [-p password]"

while getopts ":y:e:u:p" opt
do
	case $opt in
		y) year=$OPTARG;;
		e) email=$OPTARG;;
		u) user=$OPTARG;;
		p) psswrd=$OPTARG;;
	esac
done

if [[ -z $year ]]
then
	echo "please enter year"
	exit 1
fi

if [[ -z $email ]]
then
	email="waldo@weber.edu"
fi

echo "Email set to: $email"

#Make temp file and decompress
echo "Aquiring data"

if [[ ! -d temp ]]
then
	`mkdir ./temp`
fi
`cd ./temp`

`wget icarus.cs.weber.edu/~hvalle/cs3030/MOCK_DATA_$year.tar.gz`
`tar -xzf MOCK_DATA_$year.tar.gz`

echo "Filtering Data"

for files in "MOCK_DATA*.csv"
do
	`sed -e 's/,,/,waldo@weber.edu,/g' temp.txt > temp.txt`
	`awk -F"," '$5==Female && $6==Canada {print $2" "$3" "$4}' $files > temp.txt`
done

echo "Data Filtered"

#compress using zip
datetime=`date +%Y_%m_%d_%H:%M` 
`zip MOCK_DATA_FILTER_$datetime.zip temp.txt`

HOST=137.190.19.87
USER=$USER
PASSWORD=$psswrd

`ftp -inv $HOST << EOF
user $USER $PASSWORD
cd
bye
EOF`

`cd ..`
`rm -r temp`
`rm MOCK_*`

echo "Data deposited"
#mail
`mail -s "FTP" $email <<< 'Successfull FTP to server'`

#crontab -e then * */6 * * * ./home/user/dirs/batraccoon_hw4.sh is how to use the cronjob properly

exit 0
