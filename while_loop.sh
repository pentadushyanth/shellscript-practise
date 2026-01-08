#! /bin/bash

# Initialize a counter variable
counter=1
max=5

# Loop while the counter is less than or equal to the maximum
while [ $counter -le $max ]
do
  echo "Count is $counter"
  # Increment the counter using C-style arithmetic
  ((counter++))
done

echo "Loop finished."
