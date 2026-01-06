#!/bin/bash

source ./common.sh
check_root


dnf install python3 gcc python3-devel -y &>>$LOG_FILE
VALIDATE $? "Python installation"

user_creation
app_setup

cd /app 
VALIDATE $? "Chnaging directory"

pip3 install -r requirements.txt &>>$LOG_FILE
VALIDATE $? "requirements installation"

service_enable

