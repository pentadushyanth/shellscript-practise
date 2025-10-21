#! /bin/bash

Userid=$(id -u)

if [ $Userid -ne 0 ]; then
    echo "Error:: Please run this script with root privilige"

fi

dnf install mysql -y

if [ $? -ne 0 ]; then
    echo " Error:: Installing mysql is failure"

else
    echo " installing mysql is success"
fi