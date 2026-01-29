#! /bin/bash

disk_usage=$(df -hT | grep -v Filesystem)  #to format th e table by removing the header row
disk_threshold=2 # in projects we will keep it as 75\
Ipaddress= $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
message=""
while IFS= read -r line
do 
    usage=$(echo $line | awk '{print $6}' | cut -d "%" -f1)
    partition=$(echo $line | awk '{print $7}')
    if [ $usage -ge $disk_threshold ]; then
        message+="High disk usage $partition: $usage % \n" 
    fi
done <<< $disk_usage 

echo -e "Message body: $message" 

sh mail.sh "practisedevopsaws2025@gmail.com" "alert email" "high disk usage" "$message" "$Ipaddress" "devops team"
