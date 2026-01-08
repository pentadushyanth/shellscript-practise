#! /bin/bash


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
source_dir=$1
dest_dir=$2
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

if [ $# -lt 2 ]; then
    Usage
fi

if [ ! -d $source_dir ]; then
    echo -e "$R $source_dir does not exist $N"
    exit 1
fi

if [ ! -d $dest_dir ]; then
    echo -e "$R $dest_dir does not exist $N"
    exit 1
fi

