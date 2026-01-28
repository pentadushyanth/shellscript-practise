#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/16-logs.log
Start_time=$(date +%s)
script_dir=$PWD
mongodb_host=mongodb.practisedevops.shop
MYSQL_HOST=mysql.practisedevops.shop


mkdir -p $LOGS_FOLDER
echo "Script started executed at: $(date)" | tee -a $LOG_FILE

check_root(){
if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi
}

VALIDATE(){ # functions receive inputs through args just like shell script args
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e " $2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? " Disabled Node js"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? " enabled Node js"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? " installed Node js"

    npm install &>>$LOG_FILE
    VALIDATE $? "installing dependencies"
}

service_enable(){
    cp $script_dir/$server_name.service /etc/systemd/system/$server_name.service
    VALIDATE $? "copying service"

# sed -i 's/<MONGODB-SERVER-IPADDRESS>/mongodb.practisedevops.shop/g' /etc/systemd/system/catalogue.service

    systemctl daemon-reload
    VALIDATE $? "daemon reload"

    systemctl enable $server_name &>>$LOG_FILE
    VALIDATE $? "$server_name enabled"

    systemctl start $server_name 
    VALIDATE $? "$server_name started"
}

user_creation(){

    id roboshop
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "creating system user"
    else 
        echo -e "user already exists...$Y SKIPPING $N"
    fi
}

app_setup(){
   
mkdir -p /app 
VALIDATE $? "creating directory"

curl -o /tmp/$server_name.zip https://roboshop-artifacts.s3.amazonaws.com/$server_name-v3.zip &>>$LOG_FILE
VALIDATE $? "downloading $server_name"
cd /app 
VALIDATE $? "change directory"

rm -rf /app/*
VALIDATE $? "removing existing code"

unzip /tmp/$server_name.zip &>>$LOG_FILE
VALIDATE $? "unzipping file" 
}

java_setup(){
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? " maven Installation"
    cd /app 
    mvn clean package &>>$LOG_FILE
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
}
app_restart(){
systemctl restart $server_name
VALIDATE $? "app restarted"
}

print_total_time(){
    End_Time=$(date +%s)
    total_time=$(( $End_Time - $Start_time))
    echo -e "Script executed in: $Y $total_time seconds $N"
}