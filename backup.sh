#!/bin/bash

<< readme
This is a script for backup and auto delete five days older backup files.

Usages:
./backup.sh <path to your source> <path to backup folder>

readme

function display_usage {
	echo "Usages: ./backup.sh <path to your source> <path to backup folder>"
}

if [ $# -eq 0 ]; then
	display_usage
fi

source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

function create_backup {
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}"
	
	if [ $? -eq 0 ]; then
		echo "Backup generated successfully for ${timestamp}"
	fi

}

function perform_rotation {
	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
	
	if [ "${#backups[@]}" -gt 5 ]; then
		echo "Performing rotation for 5 days"
		
		backups_to_remove=("${backups[@]:5}")
		echo "$backups_to_remove"

		for backup in "${backups_to_remove[@]}";
		do
			rm -f ${backup}
		done
	fi

}

create_backup
perform_rotation

