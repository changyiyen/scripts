#!/bin/bash
# Author: Chang-Yi Yen (changyiyen@gmail.com), NCKU Med106
# Set this script to be run as root, using cron
echo "Starting weekly backup..."

# Here the cd is crucial; else the cleanup carried out below would raise hell...
cd /home/backup106/backups ## change this to absolute path ##
if [ "$!" != "0" ]; then
	echo "Error cd'ing."
	exit 1
fi

t=`date '+%F-%H-%M'`
tar -cjf ${t}bbs.tar.bz2 /home/bbs
if [ "$!" != "0" ]; then
        echo "Error occurred while creating tarball. Deleting tarball..."
        rm ${t}bbs.tar.bz2
        echo "Deleted tarball."
        exit 2
fi

echo "Cleaning up..."
filecount=`ls | wc -l`
if [ $filecount -gt 2 ]; then
	# Assuming all files are named by date, and would sort correctly from
	# oldest to newest. Default is to keep 2 backup files (x).
	x=2
	ls | head -n $(($filecount-$x)) | tr '\n' '\0' | xargs -0 rm
	echo "$(($filecount-2)) file(s) deleted"
else
	echo "No files deleted"
fi
echo "Cleanup complete"
# Here we can have different mechanisms of alerting the sysadmin that the backup
# is finished. Sendmail is pretty complicated, so we're using an empty file as a
# signal.
cd ..
rm finished_backup* # Clear previous signal files
touch finished_backup_${t} # Make signal file
return 0
