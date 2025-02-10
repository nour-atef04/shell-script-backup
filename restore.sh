#!/bin/bash

if [ $# -lt 2 ]
then
	echo "too few arguments"
elif [ ! -d $1 ]
then
	echo "$1 not found"
elif [ ! -d $2 ]
then
	echo "$2 not found"
else
	if [ ! -f "$1-currentBackup.txt"  ]
	then
		currentBackup=$(ls -t $2 | head -n 1)
	else
		currentBackup=$(cat "$1-currentBackup.txt")
	fi

	while ( true )
	do
		echo $currentBackup > $1-currentBackup.txt
		echo "==========================================================="
		echo "current backup : $currentBackup"
		echo
		echo "other backups : "

		backups=$(ls $2)

		echo "$backups"
		echo
		echo "input 1: restore back"
		echo "input 2: restore forward"
		echo "input 3: exit"
		echo

		read -p "select an option: " option

		echo

		prevDirectory=""
		nextDirectory=""

		if [ $option -eq 1 ]
		then
			for backup in $backups
			do
				if [ "$backup" = "$currentBackup" ]
				then
					break
				else
					prevDirectory=$backup
				fi
			done

		if [ -z $prevDirectory ]
		then
			echo "No older backup available to restore"
		else
			rm -r $1/*
			cp -r $2/$prevDirectory/* $1/
			echo "Restored to a previous version: $prevDirectory"
			currentBackup=$prevDirectory
		fi

		elif [ $option -eq 2 ]
		then
			reverseBackups=$(ls -r $2)
			for backup in $reverseBackups
			do
				if [ "$backup" = "$currentBackup" ]
				then
					break
				else
					nextDirectory=$backup
				fi
			done

			if [ -z $nextDirectory ]
			then
				echo "No newer backup available to restore"
			else
				rm -r $1/*
				cp -r $2/$nextDirectory/* $1/
				echo "Restored to a next version: $nextDirectory"
				currentBackup=$nextDirectory
			fi

		elif [ $option -eq 3 ]
		then
			break
		else
			echo "unavailable option"
		fi
	done
fi

