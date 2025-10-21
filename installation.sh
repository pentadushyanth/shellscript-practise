#! /bin/bash

Userid=$(id -u)

if [ $Userid -ne 0 ]; then
    echo "Error:: Please run this script with root privilige"
    exit 1 #failure is pther than 0
fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo " Error:: Installing mysql is failure"
    exit 2
else
    echo " installing mysql is success"
fi