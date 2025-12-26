#! bin/bash

ami_id="ami-09c813fb71547fc4f"
sg_id="sg-055d475babe24887e"
zone_id="Z00418011PRHOYGK0K56N"
domain_name="practisedevops.shop"
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
    Record_name="$instance.$domain_name"
  else
     IP=$(aws ec2 describe-instances \
    --instance-ids $Instance_ID  \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)
    Record_name="$domain_name"
  fi

  echo "$instance instance $IP"
 
 aws route53 change-resource-record-sets \
  --hosted-zone-id $zone_id \
  --change-batch '
  {
    "Comment": "updating record set"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$Record_name'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "' $IP '"
        }]
      }
    }]
  }
  '
done