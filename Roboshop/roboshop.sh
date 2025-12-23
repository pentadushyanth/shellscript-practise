#! bin/bash

ami_id="ami-09c813fb71547fc4f"
sg_id="sg-055d475babe24887e"

for instance  in $@
do 
    Instance_ID=$(aws ec2 run-instances --image-id $ami_id  --instance-type t3.micro  \
    --security-group-ids $sg_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' --output text)
  if [ $instance != "frontend" ]; then
    IP=$(aws ec2 describe-instances \
    --instance-ids $Instance_ID  \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text)
  else
     IP=$(aws ec2 describe-instances \
    --instance-ids $Instance_ID  \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)
  fi
done
 