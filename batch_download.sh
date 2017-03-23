#!/bin/bash

#  batch_download.sh - automated downloading of illustrations from wenku8.cn

#  Author: Chang-Yi Yen (changyiyen@gmail.com)
#  Version: 0.1 (2012.9.8)

#  This bit of code is hereby placed in the public domain;
#  use it however you wish! If you really want to thank me,
#  get out there and buy me some Kadokawa light novels! :)

#  Usage: invoke this script with the pathnames of the illustration-wrapper HTML
#  files as arguments.

#  Usage example: $ ./batch_download.sh 30969.htm 33167.htm 34437.htm
#  (in this case the script is in the same directory as the wrapper HTML files)

#  Exit statuses:
#  0: No errors
#  1: Wrong Bash version (Bash too old)
#     (Specifically, this script uses associative arrays introduced in Bash 4)
#  2: No arguments given

if [ "$BASH_VERSINFO" -lt "4" ]; then
	echo "This script needs at least Bash version 4 to run."
	exit 1
fi

##script for downloading picts from wenku8.cn server
echo "wenku8.cn illustration batch download script"
if [ $# -eq 0 ]; then	
	echo "usage: $0 image_page_1 image_page_2 ..."
	exit 2
fi

##gets download directory; default is current directory
echo "Enter directory to download to (default is current directory; hit return"
read -p "to skip): " input_download_dir

##make an associative array to catch error codes
declare -A errors

for file in $@; do
	##go to HTML file directory
	cd `dirname $file`

	##get picture URLs
	pictname=`grep -P -o 'http://pic\.wenku8\.cn.*?(jpg|jpeg|gif|png)' $file`
	if [ "$?" -eq "1" ]; then
		echo "Error: picture URLs not found."
		errors["$file"]+=1
		continue
	elif [ "$?" -ge "2" ]; then
		echo "Error: an error occurred during grep."
		errors["$file"]+=1
		continue
	fi

	##go to specified download directory if it exists (mkdir if it doesn't)
	if [ "$input_download_dir" != "" ]; then
		if [ -d "$input_download_dir" ]; then
			cd $input_download_dir
		else
			mkdir $input_download_dir
		fi
	fi
	if [ "$?" -ne "0" ]; then
		echo "Error: couldn't change directory to $download_dir"
		errors["$file"]+=1
		continue
	fi

	##make a directory named after webpage
	new_dirname=`basename $file | sed 's/.htm//'`
	mkdir $new_dirname
	
	cd $new_dirname ##note that if mkdir fails (due to permissions, etc.)
				    ##it will crash cd here
	if [ "$?" -ne "0" ]; then
		echo "Error: couldn't change directory to $new_dirname"
		errors["$file"]+=1
		continue
	fi
	
	##download the pictures
	if [ "$pictname" != "" ]; then
		wget --wait=5 --random-wait -nc $pictname
	fi

	##check for any download errors
	if [ "$?" -ne "0" ]; then
		errors["$file"]+=1
	fi
	
	##return to original specified directory
	cd ..
done

##show errors
for f in "${!errors[@]}"; do
	echo "${errors["$f"]} errors were encountered while processing $f"
done

exit 0
