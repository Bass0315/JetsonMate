#!/bin/bash
sudo cp worker/static_ip/worker1_ip /etc/network/interfaces.d/eth0

sudo cp worker/static_ip/interfaces /etc/network/

sudo /etc/init.d/networking restart

sleep 1

sudo reboot