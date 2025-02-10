SOURCE := $(shell pwd)/Dir
BACKUP := $(SOURCE)Backup
BACKUP_SHELL := $(shell pwd)/backup.sh
RESTORE_SHELL := $(shell pwd)/restore.sh
INTERVAL_SECS := 5
MAX_BACKUPS := 5
BACKUP_CRON := $(shell pwd)/backup-cron.sh
BACKUP_CRON_LOG := $(shell pwd)/Logs/backup-cron.log
DATE_SCRIPT := $(shell pwd)/Logs/date-script.sh
DATE_OUTPUT := $(shell pwd)/Logs/date-output.txt

backup: prebuild run_backup

cron_start: prebuild run_cron

prebuild:
	@if [ ! -d $(BACKUP) ]; then \
		mkdir -p $(BACKUP); \
		echo "Backup directory is ready: $(BACKUP)"; \
		echo; \
	fi

run_backup:
	@$(BACKUP_SHELL) $(SOURCE) $(BACKUP) $(INTERVAL_SECS) $(MAX_BACKUPS)

restore:
	@$(RESTORE_SHELL) $(SOURCE) $(BACKUP)

run_cron:
	@echo "* * * * * ( sleep 22 && $(BACKUP_CRON) $(SOURCE) $(BACKUP) $(MAX_BACKUPS) >> $(BACKUP_CRON_LOG) 2>&1 )" | crontab -
	@( crontab -l ; echo "* * * * * ( sleep 22 && $(DATE_SCRIPT) &>> $(DATE_OUTPUT) )" ) | crontab -
	@echo "Cron job started"
 
cron_end:
	@echo "" | crontab -
	@echo "Cron job ended"

clean:
	@echo "Removing backups..."
	@rm -r $(BACKUP) /*
