#! /bin/bash

disk_usage=$(df -hT | grep -v Filesystem)  #to format th e table by removing the header row

while IFS= read -r line
do 
    echo "Line: $line"

done <<< $disk_usage 