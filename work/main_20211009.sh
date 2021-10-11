#!/bin/bash

stty -F /dev/ttyS0 raw speed 115200
stty -F /dev/ttyS0 raw speed 115200

pkill cat 

cat /dev/ttyS0 > temporary.log &
ttyS0_process=$!
#kill -9 "$ttyS0_process"
		
while true
do
	if [ `grep -c "Worker start" temporary.log` -ne '0' ];then
	
		rm -rf 'Worker*'   Worker3*

		# Get master ip
		echo $(sed -n '1,1p' temporary.log | cut -c 1-15) > master_ip.log
		echo $(sed -n '1,1p' temporary.log | cut -c 1-15)
		echo "" > temporary.log
			
		# USB3.0
		ls  /dev/sd* > temporary.log
		if [ "$?" -eq 0 ]; then
			if [ `grep -c "/dev/sd" temporary.log` -ne '0' ];then  #Count the number of columns that match the style.
				echo "mount sd*"
				mount $(sed -n '2,2p' temporary.log) /mnt/ 
				if [ "$?" -eq 0 ]; then
					cp /mnt/Worker* .
					echo "" > Worker*
					echo $(date "+%Y-%m-%d %H:%M:%S") >> Worker*
					echo "USB3.0 OK" >> Worker*
				else
					echo $(date "+%Y-%m-%d %H:%M:%S") >> Worker*
					echo "USB3.0 Error" >> Worker*
				fi
			else
				echo "USB3.0 Error" >> Worker*
			fi
		else
		
		fi
		

		echo "" > temporary.log
		
		# Fan 
		python fan.py
		
		# Different Worker stop for different times,The Worker client will complete iperf3 at various points in time.
		ls Worker* > temporary.log
		sleep $((($(sed -n '1,1p' temporary.log | cut -c 7-7)-1)*5))
	
		# Uart Tx
		echo $(ls /mnt/Worker*) > /dev/ttyS0   # if master can receive this message,Uart is ok
		
		# Eth
		iperf3 -c $(cat master_ip.log) -i 0.1 -t 1 > temporary.log  # Must set a service
		echo $(sed -n '16,16p' temporary.log | cut -c 40-43)
		if [ 500 -lt $(sed -n '16,16p' temporary.log | cut -c 40-43) ];then
				echo "Eth"
				echo "Eth OK" >> Worker*
		else
				echo "Eth Error" >> Worker*
		fi			
		
		# # Return report log to master  
		# echo ${master_ip}		
		# sshpass -p 123 scp -r Worker* seeed@${master_ip}:/home/seeed/Desktop/JetsonMate/  # The host trust must be in path /root/.ssh/known_hosts
		./sshpass.sh
		
		#
		echo "" > temporary.log
		cp Worker* /mnt/
		rm -rf Worker*
	fi
done