#!/bin/bash - 
#===============================================================================
#
#          FILE: getopts.sh
# 
#         USAGE: ./getopts.sh 
# 
#   DESCRIPTION: 
# 
#        AUTHOR: Matthew Smith (), matthewsmith4@mail.weber.edu
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
		y)year=$OPTARG;;
			if ( ! = $year )
				echo "please put in year"
				exit 1
			fi
		e)email=$OPTARG;;
			if ( ! = $email)
				email="waldo@weber.edu"
			fi;;
		u)user=$OPTARG;;
		p)psswrd=$OPTARG
	esac
done

#Make temp file and decompress
mkdir temp
cd temp
wget icarus.cs.weber.edu/~hvalle/cs3030/MOCK_DATA_$year.tar.gz
tar -vxzf MOCK_DATA_$year.tar.gz

for files in "MOCK_DATA*.csv"
do
	awk -F"," '$5==Female && $6==Canada {print $2" "$3" "$4}' $files > temp.txt
	if (-z $4)
	then 
		sed -e 's/,,/,waldo@weber.edu,/g' temp.txt > temp.txt
	fi
done

#compress using zip

exit 0
