#!/bin/bash

Master_ip="192.168.237.110"

/etc/init.d/networking restart
# Waiting for master turn on to complete
sleep 40

# Eth
ifconfig eth0 > temporary.log
if [ `grep -c "inet 192.168" temporary.log` -ne '0' ];then
	touch Worker$(sed -n '2,2p' temporary.log | cut -c 28-28).log
	echo Worker$(sed -n '2,2p' temporary.log | cut -c 28-28)__$(sed -n '2,2p' temporary.log | cut -c 14-28)__$(date "+%Y-%m-%d %H:%M:%S") >> Worker*
	echo $(sed -n '2,2p' temporary.log | cut -c 14-28) >> Worker*	# Get Worker ip to Worker*.log
	
	sleep $((($(sed -n '2,2p' temporary.log | cut -c 28-28)-1)*4))
	
	iperf3 -c ${Master_ip} -i 0.1 -t 1 > temporary.log	# Must set a service
	if [ "$?" -eq 0 ]; then		# iperf3 command ok
		echo "$(sed -n '16,16p' temporary.log | cut -c 40-43)M" >> Worker*
		if [ 500 -lt $(sed -n '16,16p' temporary.log | cut -c 40-43) ];then
			echo "Eth OK" >> Worker*
		else
			echo "Eth Error" >> Worker*
		fi	
	else
		echo "Eth Error" >> Worker*
	fi	
else
	touch Worker_DisplayUSB
	echo "Eth Error" >> Worker*
fi


# Fan
python fan.py

# << Report result >>
# Report to U disk
ls  /dev/sd* > temporary.log
if [ "$?" -eq 0 ]; then
	mount $(sed -n '2,2p' temporary.log) /mnt/
	if [ "$?" -eq 0 ]; then		# mount sd* ok
		echo "USB OK" >> Worker*
		ls /mnt/ >> temporary.log
		if [ `grep -c "Worker*" temporary.log` -ne '0' ];then
			rm -rf /mnt/Worker*
		fi
		cp Worker* /mnt/
		
		sleep 0.1
		umount $(sed -n '2,2p' temporary.log)
	else						# mount sd* error
		echo "Mount sd* Error" >> Worker*
	fi
else
	echo "USB Error" >> Worker*
fi

# Report to sshpass scp
sshpass -p 123 scp -r Worker* seeed@${Master_ip}:/home/seeed/Desktop/JetsonMate/

sleep 0.1

rm -rf Worker*

systemctl stop test

while true
do
	sleep 1
done
