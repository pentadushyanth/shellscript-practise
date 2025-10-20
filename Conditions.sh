#! /bin/bash/

number= $1

if [ $number -lt 10];then
     echo "Gibven number $number is less than 10"
elif [ $number -eq 10];then
    echo " given number $number is equal to 10"

else
    echo "Given number   $number is greater than or equal to 10"
fi       