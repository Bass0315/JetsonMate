#!/bin/bash

master_ip=$(cat master_ip.log)
sshpass -p 123 scp -r Worker* seeed@${master_ip}:/home/seeed/Desktop/JetsonMate/
