#! /bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

logsfolder="/var/log/shellscript"
scriptname=$( echo $0 | cut -d "." -f1 ) #this will cut the file extension
logfile="$logsfolder/$scriptname.log"


mkdir -p $logsfolder
echo "script started executed at: $(date)"
Userid=$(id -u)

if [ $Userid -ne 0 ]; then
    echo "Error:: Please run this script with root privilige"
    exit 1 #failure is pther than 0
fi


validate(){ #functions recieve inputs through args just like shell script args
if [ $1 -ne 0 ]; then
    echo -e " Error:: Installing $2 .....$R failure" | tee -a $logfile  # this will append this statement in the log file 
    exit 2
else
    echo -e " installing $2.....$G is success" | tee -a $logfile
fi

}

dnf list installed mysql &>>$logfile
if [ $? -ne 0 ]; then
    dnf install mysql -y &>>$logfile
    validate $? "Mysql"
else
    echo -e "Mysql already exist....$Y Skipping $N" | tee -a $logfile
fi 

dnf list installed nginx &>>$logfile
if [ $? -ne 0 ]; then
    dnf install nginx -y &>>$logfile
    validate $? "nginx"
else
    echo -e "nginx already exist....$Y Skipping $N" | tee -a $logfile 
fi 

dnf list installed python3 &>>$logfile
if [ $? -ne 0 ]; then
    dnf install python3 -y &>>$logfile
    validate $? "python3"
else
    echo -e "python3 already exist....$Y Skipping $N" | "tee -a $logfile
fi 


