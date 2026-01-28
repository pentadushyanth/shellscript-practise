#!/bin/bash
source ./common.sh
server_name=shipping

check_root

user_creation
app_setup
java_setup
service_enable


dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql installed"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
VALIDATE $? "checking schema"

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    VALIDATE $? "schema added "
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    VALIDATE $? "user data added"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "master data added"
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi


app_restart

print_total_time