#!/bin/bash

source ./common.sh
check_root

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


