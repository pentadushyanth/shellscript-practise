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

dnf install maven -y
VALIDATE $? " maven Installation"

id roboshop
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "creating system user"
else 
    echo -e "user already exists...$Y SKIPPING $N"
fi


mkdir -p /app 
VALIDATE $? "creating directory"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading shipping"
cd /app 
VALIDATE $? "change directory"

rm -rf /app/*
VALIDATE $? "removing existing code"

unzip /tmp/shipping.zip &>>$LOG_FILE
VALIDATE $? "unzipping file"

cd /app 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE

cp $script_dir/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "copying service"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable shipping &>>$LOG_FILE
VALIDATE $? "shipping enabled"

systemctl start shipping &>>$LOG_FILE
VALIDATE $? "shipping started"


dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "mysql installed"

mysql -h $Mysql_Host -uroot -pRoboShop@1 -e 'use mysql'

if [ $? -ne 0 ]; then
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE  
    mysql -h $Mysql_Host -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is alreay loaded... $Y SKIPPING $N"
fi
systemctl restart shipping