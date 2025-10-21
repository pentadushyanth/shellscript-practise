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
    echo "please enter tool name"
    read tool
    if [ $tool -ne 0]; then
        dnf install $tool -y
        validate $? "$tool"
    else 
        exit 3
    fi        

fi

}

echo "please enter tool name"
read tool

dnf install $tool  -y
validate $? "$tool"

