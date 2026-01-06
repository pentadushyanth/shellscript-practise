#!/bin/bash


source ./common.sh
server_name=cart
check_root

app_setup

nodejs_setup
user_creation
service_enable
app_restart
print_total_time