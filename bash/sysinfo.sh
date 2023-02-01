#!/bin/bash
echo "FQDN:"
hostname --fqdn
echo "Host Information"
hostnamectl
echo "IP Address:"
ip address show ens33 | grep "inet"
echo "Space:"
df -h
