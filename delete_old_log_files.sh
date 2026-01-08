#! /bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log

mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

source_dir=/home/ec2-user/app-logs
if [! -d $source_dir ];then
    echo -e "ERROR:Source directory does not exist"
fi

File_to_delete=$(find $source_dir -name "*.log" -type f -mtime +14)
