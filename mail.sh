#! /bin/bash

to_address=$1
subject=$2
alert_type=$3
msg_body=$4
Formatted_body=$(printf '%s\n' "$msg_body" | sed -e "s/'/'\\\\''/g;1s/^/'/; \$s/\$/'/")
Ipaddress=$5
to_team=$6

Final_body=$(sed -e "s/to_team/$to_team/g" -e "s/alert_type/$alert_type/g" -e "s/Ipaddress/$Ipaddress/g" -e "s/message_body/$Formatted_body/g" template.html)

{
echo "To: $to_address"
echo "Subject: $subject"
echo "Content-Type: text/html"
echo ""
echo "$Final_body"
} | msmtp "$to_address"