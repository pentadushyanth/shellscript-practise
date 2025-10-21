#! /bin/bash

Userid=$(id -u)

if [ $Userid -ne 0 ]; then
    echo "Error:: Please run this script with root privilige"
    exit 1 #failure is pther than 0
fi

validate(){ #functions recieve inputs through args just like shell script args
if [ $1 -ne 0 ]; then
    echo " Error:: Installing $2 is failure"
    exit 2
else
    echo " installing $2 is success"
fi

}
dnf install mysql -y
validate $? "Mysql"

dnf install nginx -y
validate $? "nginx"


dnf install python3 -y
validate $? "python3"
