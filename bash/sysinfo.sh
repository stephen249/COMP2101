#!/bin/bash
# Modifying the sysinfo script following the output template

# Gathering the Data and putting them in the variables
# Using variable data1 for showing the hostname
data1=$(hostname --fqdn)

# Using variable data2 for storing the value for the Operating System
data2=$(hostnamectl| grep "Operating System" | awk '{print $3 , $4, $5}')
# Using Varaible data3 for getting the I.P. address
data3=$(ip route | grep "default" | awk '{print $3}')
# Using Variable data 4 for getting the disk space
data4=$(df -H | grep "/dev/sda3" | awk '{print $4}')
#Executing the script 
cat <<EOF
Report for myvm
=========
FQDN: $data1
Operating System name and version: $data2
I.P. Adress: $data3
Root Filesystem Free Space: $data4
=========
EOF

