#!/bin/bash

source ./common.sh
server_name=catalogue
check_root

app_setup

nodejs_setup
user_creation
service_enable


cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installing mongodb"

Index=$(mongosh $mongodb_host --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [[ "$Index" -le 0 ]]; then
    mongosh --host $mongodb_host </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "loading master data "
else
    echo -e "catalogue producsts already loaded $Y Skipping $N"
fi

app_restart

print_total_time
