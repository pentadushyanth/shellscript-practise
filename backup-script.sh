#! /bin/bash


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
source_dir=$1
dest_dir=$2
days=${3:-14}  #if not provided default to 14
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

Usage(){
    echo "usage:: sudo sh backup-script.sh <source dir> <dest dir> <days> [optional], default 14 days"
    exit 1
}

## check source dir and dest directory passes pr npt
if [ $# -lt 2 ]; then
    Usage
fi
#check source dir exist or not
if [ ! -d $source_dir ]; then
    echo -e "$R $source_dir does not exist $N"
    exit 1
fi
#check dest dir exist or not
if [ ! -d $dest_dir ]; then
    echo -e "$R $dest_dir does not exist $N"
    exit 1
fi
# Find the files
Files=$(find $source_dir -name "*.log" -type f)

if [ ! -z "${Files}" ]; then
    ## start archieving
    echo "files found: $Files"
    Timestamp=$(date +%F-%H-%M)
    zip_File_name="$dest_dir/app-log-$Timestamp.zip"
    echo "Zipfile name: $zip_File_name"
    find $source_dir -name "*.log" -type f | zip -@  -j "$zip_File_name"
    
    #check archieval
    if [ -f $zip_File_name]
    then 
        echo -e " Archieval....$G Success $N"
        # Delete if success
        while IFS= read -r filepath
        do 
            echo "deleting the file: $filepath"
            rm -rf $filepath
            echo "deleted the file: $filepath"
        done <<< $Files
    else
        echo " Archieval .... $R Failure $N"
        exit 1
    fi
else
    echo "No files to archive....$Y Skipping $N"
fi