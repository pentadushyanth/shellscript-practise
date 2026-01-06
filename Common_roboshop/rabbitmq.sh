#!/bin/bash

source ./common.sh
check_root


cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Adding rabbitmq repo"
dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enable rabbit mq"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Start rabbitmq"


rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "adding user"


print_total_time