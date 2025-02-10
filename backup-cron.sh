#!/bin/bash

if [ $# -lt 3 ]
then
	echo "too few arguments"
elif [ ! -d $1 ]
then
	echo "$1 not found"
elif [[ ! $3 =~ ^[0-9]+$ ]]
then
	echo "$3 should be a number"
else

	currentDate=$(date +"%Y-%m-%d-%H-%M-%S")

	echo "Backup created at $2/$currentDate"
	mkdir -p $2/$currentDate
	cp -r $1/* $2/$currentDate 
	echo $currentDate > $1-currentBackup.txt
	
	directoryCount=$(ls $2 | wc -l)
	if [ $directoryCount -gt $3 ]
	then
		directoryToDelete=$(ls -t $2 | tail -n 1)
		rm -r $2/$directoryToDelete 
	fi

fi
