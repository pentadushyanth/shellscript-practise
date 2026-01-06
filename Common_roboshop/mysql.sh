#!/bin/bash

source ./common.sh
check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? " mysql installed"

systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "mysql started"

mysql_secure_installation --set-root-pass RoboShop@1 
VALIDATE $? "setting root password"

print_total_time