#! /bin/bash/

#Date=$(date)

start_time=$(date +%s)

sleep 10 

end_time=$(date +%s)
Total_time=$(($end_time-$start_time))
echo "script executed in  : $Total_time seconds" 