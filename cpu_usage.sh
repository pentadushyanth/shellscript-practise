#! /bin/bash

disk_usage=$(df -hT | grep -v Filesystem)  #to format th e table by removing the header row
disk_threshold=2 # in projects we will keep it as 75
while IFS= read -r line
do 
    usage=$(echo $line | awk '{print $6}' | cut -d "%" -f1)
    partition=$(echo $line | awk '{print $7}')
    if [ $usage -ge $disk_threshold ]; then
        
        {
            echo "To: practisedevopsaws2025@gmail.com"
            echo "Subject: High usage alert email"
            echo "Content-Type: text/html"
            echo ""
            echo " High usage on $partition: $usage"
        } | msmtp "practisedevopsaws2025@gmail.com"
    fi
done <<< $disk_usage 