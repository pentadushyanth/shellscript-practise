#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? " redis disabled"
dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? " redis enabled"
dnf install redis -y &>>$LOG_FILE
VALIDATE $? " redis installed"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf 
VALIDATE $? "Allowing remote connection to redis"

sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf 
VALIDATE $? "protected mode is disabled"

systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
VALIDATE $? "redis started"

print_total_time
