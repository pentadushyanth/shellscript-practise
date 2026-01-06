#!/bin/bash

source ./common.sh
server_name=shipping

check_root


dnf install maven -y &>>$LOG_FILE
VALIDATE $? " maven Installation"

user_creation
app_setup


cd /app 
mvn clean package &>>$LOG_FILE
mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE

service_enable


dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql installed"

mysql -h mysql.practisedevops.shop -uroot -pRoboShop@1 -e 'use mysql'
if [ $? -ne 0 ]; then
    mysql -h mysql.practisedevops.shop -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.practisedevops.shop -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE  
    mysql -h mysql.practisedevops.shop -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is alreay loaded... $Y SKIPPING $N"
fi

app_restart