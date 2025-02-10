OVERVIEW

This project provides a way to backup directories, and to manage different versions of the source directory. The backup script will automatically backup a directory each interval of seconds, by making a copy of the source directory in the backup directory with current dates, until reaching a maximum number of backups and removing old ones. The restore script will allow the user to navigate through previous and future backups that were created previously in the backup script. 
The project also contains an implementation of a cron job, which allows the backup job to run in the background every 1 minute without the user manually entering the backup command.

======================================================================================================================

FOLDER STRUCTURE

LAB2/
|__ Dir/
|__ Logs/
    |__ backup-cron.log
    |__ date-output.txt
    |__ date-script.sh
|__ backup.sh
|__ backup-cron.sh
|__ Makefile
|__ README.md
|__ restore.sh

======================================================================================================================

PREREQUISITES NEEDED

Before running the "make" command, you need to install it (if it's not already installed in your terminal) by the following: 

sudo apt update
sudo apt install make 

IN CRON

You need to also install cron (if it's not already installed in your terminal) by the following:

sudo apt update
sudo apt install cron

======================================================================================================================

HOW TO RUN THE PROJECT

----------------------------------------------------------------------------------------------------------------------

STEP 1: CREATE "DIR" FOLDER

If the directory "Dir" is not in your folder, then create it, following the folder structure provided above. 

----------------------------------------------------------------------------------------------------------------------

STEP 2: ADJUSTING PARAMETERS OF THE BACKUP OPERATION

If you wish to adjust the source directory, the number of seconds between each backup, and the number of maximum number of backups, then open the Makefile by running the following: 

nano Makefile

Then replace the "..." in the following code snippet to your desired parameters:

SOURCE := $(shell pwd)/...
BACKUP := $(SOURCE)Backup
INTERVAL_SECS := ...
MAX_BACKUPS := ...

----------------------------------------------------------------------------------------------------------------------

STEP 3: RUNNING THE BACKUP PART

Run the backup shell using:

make backup

----------------------------------------------------------------------------------------------------------------------

STEP 4: RUNNING THE RESTORE PART

Run the restore shell using:

make restore

It's preferable to run the restore shell after making sure that the cron job isn't working in the background, to avoid trying to restore a backup that gets deleted as you're restoring it. Steps to end a cron job are covered below in the "configuring the cron job" section.

----------------------------------------------------------------------------------------------------------------------

STEP 5: REMOVE THE BACKUP FOLDERS

If you wish to remove the backup folders created, run the following:

make clean

----------------------------------------------------------------------------------------------------------------------

CONFIGURING THE CRON JOB

----------------------------------------------------------------------------------------------------------------------

STEP 1: STARTING THE CRON JOB

Run the command:

make cron_start

Error logs are written in the backup-cron.log. The date logs are written in the date-out.txt.

----------------------------------------------------------------------------------------------------------------------

STEP 2: ENDING THE CRON JOB

Run the command:

make cron_end

----------------------------------------------------------------------------------------------------------------------

STEP 3: EDITING CONFIGURATIONS OF THE CRON JOB

You can edit the cron jobs, using the Makefile, or the crontab editor.
To edit by the Makefile, run the command:

nano Makefile

Then it will open the Makefile file. You will find:


cron_start:
	@echo "* * * * * ( sleep 22 && $(BACKUP_CRON) $(SOURCE) $(BACKUP) $(INTERVAL_SECS) &>> $(BACKUP_CRON_LOG) )" | crontab -
	@( crontab -l ; echo "* * * * * ( sleep 22 && $(DATE_SCRIPT) &>> $(DATE_OUTPUT) )" ) | crontab -

cron_end:
	@echo "" | crontab -
	

From here you can edit the time interval between each background backup, or the time interval it sleeps, or the location of the logs. You can also edit directly from the crontab editor by running:

crontab -e

Note that if you adjusted sleep to 22, it will backup at second 23 because of a 1 second delay. Make sure to adjust the time one second lower than your desired number of seconds.

Another note is that if you edit from the cron directly, the cron job is automatically started when you save. However, if you wish to run the command "make cron_start" afterwards, it will overwrite the lines in the cron editor by the lines found in the Makefile.

Example: If you wish to run the backup every 3rd Friday of the month at 12:31 am, then edit the Makefile file to be:

cron_start:
	@echo "31 00 * * Fri [ $(date +"%d") -ge 15 ] && [ $(date +"%d") -le 21 ] && $(BACKUP_CRON) $(SOURCE) $(BACKUP) $(INTERVAL_SECS) &>> $(BACKUP_CRON_LOG)" | crontab -
	@( crontab -l ; echo "* * * * * ( sleep 22 && $(DATE_SCRIPT) &>> $(DATE_OUTPUT) )" ) | crontab -
	
Explanation:

31 -> at minute 31
00 -> at 12 am (so every 00:31)
Fri -> every friday
[ $(date +"%d") -ge 15 ] && [ $(date +"%d") -le 21 ] -> condition to check if this day of the month falls on the 3rd week. Since the first friday is sure to fall between 1st or 7th of the month, then the third friday is sure to fall between 15th and 21st. Therefore, we check if the date falls in this range before proceeding to the running of the backup.

======================================================================================================================



