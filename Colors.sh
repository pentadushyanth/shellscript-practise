#! /bin/bash/

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


Userid=$(id -u)

if [ $Userid -ne 0 ]; then
    echo "Error:: Please run this script with root privilige"
    exit 1 #failure is pther than 0
fi

validate(){ #functions recieve inputs through args just like shell script args
if [ $1 -ne 0 ]; then
    echo -e " Error:: Installing $2 .....$R failure $N"
    exit 2
else
    echo -e " installing $2.....$G is success $N"
fi

}

dnf list installed mysql
if[ $? -ne 0 ]; then
    dnf install mysql -y
    validate $? "Mysql"
else
    echo -e "Mysql already exist....$Y Skipping $N"
fi 

dnf list installed nginx
if[ $? -ne 0 ]; then
    dnf install nginx -y
    validate $? "nginx"
else
    echo -e "nginx already exist....$Y Skipping $N"
fi 

dnf list installed python3
if[ $? -ne 0 ]; then
    dnf install python3 -y
    validate $? "python3"
else
    echo -e "python3 already exist....$Y Skipping $N"
fi 

