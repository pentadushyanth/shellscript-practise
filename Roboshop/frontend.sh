#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
script_dir=$PWD
mongodb_host=mongodb.practisedevops.shop
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
Mysql_Host=mysql.practisedevops.shop
mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e " $2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

dnf module list nginx &>>$LOG_FILE
VALIDATE $? " Listing nginx"

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? " disabled nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? " enabled nginx"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? " installed nginx"


systemctl enable nginx  &>>$LOG_FILE
VALIDATE $? "nginx enabled"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "nginx started"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removed nginx html"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading catalogue"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping file"



cp $script_dir/nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "copying content"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting nginx"


