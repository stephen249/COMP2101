#!/bin/bash

# The Script is for Lab 3

# Using the which command in order to see whether we have the lxd on the system already or not

#Just Use the root in order to run the script

which lxd >/dev/null
if [ $? -ne 0 ]; then
	# If this condition is true we have to install the lxd
	echo "In this case we have to install the lxd"
	sudo snap install lxd
	if [ $? -ne 0 ]; then
		# If the Installation fails or we already have the lxd
		echo "Failed to install the lxd which is essential to complete the lab"
		exit 1
	fi
fi

#Showing and Checking if the interface lxdbr0 exists or not
echo "The interface :"
ls /sys/class/net | grep "lxdbr0" && echo "Yes the interface exists and is running fine"

#Running the lxd init command if lxdbr0 interface doesn't exit
if [ $? -ne 0 ]; then
	sudo lxd init --auto
	echo "The Configuration is done"
fi

#Launching the container named COMP2101-S22
sudo lxc launch ubuntu:20.04 COMP2101-S22

#Using the command if the COMP2101-S22 exists or not in the /etc/hosts
echo "The Configuration"
cat /etc/hosts | grep "COMP2101-S22" && echo "The COMP2101-S22 exists Yeeeh We don't have to add onto the file"

# If there is no COMP201-S22 than Updating the entry in /etc/hosts/ for hostname COMP2101-S22
if [ $? -ne 0 ]; then 
	sudo echo "10.127.105.169 COMP2101-S22" >> /etc/hosts
fi
# Checking if the apache 2 
systemctl status apache2 | grep "Active" | awk '{print $2}'| echo "Apache2 is active and running"

# Installing the Apache 2 if we don't have in the container
if [ $? -ne 0 ]; then
	lxc exec COMP2101-S22 -- apt install apache2
fi
#Checking if the curl is installed or not
curl --version | grep "curl" | awk '{print $1}' | echo "Curl is active and running"
# Installing the curl
if [ $? -ne 0 ]; then
	apt install curl
fi

# Retrieving the Default web Page and showing if it success or failure

curl http://COMP2101-S22
#Providing the success or the failure message

if [ $? -ne 0 ]; then
	echo "The Failure"
else
	echo "The Success"
fi

#End of the Script
