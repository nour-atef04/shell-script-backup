#!/bin/bash

if [ $# -lt 4 ]
then
	echo "too few arguments"
elif [ ! -d $1 ]
then
	echo "$1 not found"
elif [[ ! $3 =~ ^[0-9]+$ ]]
then
	echo "$3 should be a number"
elif [[ ! $4 =~ ^[0-9]+$ ]]
then
	echo "$4 should be a number"
else

	currentDate=$(date +"%Y-%m-%d-%H-%M-%S")

	if [ ! -d $2 ]
	then
		mkdir -p $2
		echo "Backup directory is ready: $2"
		echo;
	fi

	echo "Backup created at $2/$currentDate"
	mkdir -p $2/$currentDate
	cp -r $1/* $2/$currentDate 
	echo $currentDate > $1-currentBackup.txt
	
	directoryCount=$(ls $2 | wc -l)
	if [ $directoryCount -gt $4 ]
	then
		directoryToDelete=$(ls -t $2 | tail -n 1)
		rm -r $2/$directoryToDelete 
	fi

	ls -lR $1 > directory-info.last
	while true
	do
		ls -lR $1 > directory-info.new
		diff directory-info.last directory-info.new > /dev/null
		if [ $? -gt 0 ]
		then
			currentDate=$(date +"%Y-%m-%d-%H-%M-%S")

			echo "Backup created at $2/$currentDate"
			mkdir -p $2/$currentDate 

			cp -r $1/* $2/$currentDate 
			cp directory-info.new directory-info.last
			echo $currentDate > $1-currentBackup.txt

			directoryCount=$(ls $2 | wc -l)
			if [ $directoryCount -gt $4 ]
			then
				directoryToDelete=$(ls -t $2 | tail -n 1)
				rm -r $2/$directoryToDelete 
			fi
		fi
		sleep $3
	done
fi
