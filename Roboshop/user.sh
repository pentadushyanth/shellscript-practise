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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? " Disabled Node js"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? " enabled Node js"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? " enabled Node js"

id roboshop
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "creating system user"
else 
    echo -e "user already exists...$Y SKIPPING $N"
fi
mkdir -p /app 
VALIDATE $? "creating directory"

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading user"
cd /app 
VALIDATE $? "change directory"

rm -rf /app/*
VALIDATE $? "removing existing code"

unzip /tmp/user.zip &>>$LOG_FILE
VALIDATE $? "unzipping file"

npm install &>>$LOG_FILE
VALIDATE $? "installing dependencies"

cp $script_dir/user.service /etc/systemd/system/user.service
VALIDATE $? "copying service"

# sed -i 's/<REDIS-IP-ADDRESS>/redis.practisedevops.shop/g' /etc/systemd/system/user.service
# sed -i 's/<MONGODB-SERVER-IPADDRESS>/mongodb.practisedevops.shop/g' /etc/systemd/system/user.service

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable user &>>$LOG_FILE
VALIDATE $? "user enabled"

systemctl start user 
VALIDATE $? "user started"
