#! /bin/bash

echo "please enter number:"
read number

if [ $(($number % 2)) -eq 0]; then
    echo " Given number $number is even"

else 
    echo "Given number $number is odd"
fi