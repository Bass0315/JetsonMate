#!/bin/bash

function displayResul(){
    if [ "$1" -eq 1 ]; then
        echo " - - - - - - - - - - - - - - - - - - - - "
        echo " -                                     - "
        echo " -              succssed               - "
        echo " -                                     - "
        echo " - - - - - - - - - - - - - - - - - - - - "  
    else
        echo " - - - - - - - - - - - - - - - - - - - - "
        echo " -                                     - "
        echo " -               failed                - "
        echo " -                                     - "
        echo " - - - - - - - - - - - - - - - - - - - - "
	fi
}

# Get master ip
ifconfig eth0 > ip.log
echo $(sed -n '2,2p' ip.log | cut -c 14-28) > ip.log 

# Start Worker test
stty -F /dev/ttyUSB0 raw speed 115200
stty -F /dev/ttyUSB0 raw speed 115200
echo "Worker start" >> ip.log
echo $(cat ip.log) > /dev/ttyUSB0    #seed ip


stty -F $(ls /dev/ttyACM*) raw speed 115200
stty -F $(ls /dev/ttyACM*) raw speed 115200
stty -F $(ls /dev/ttyACM*) raw speed 115200



# Background temporary
echo "" > temporary.log
cat $(ls /dev/ttyACM*) >> temporary.log &
ttyACM_process=$!

python3 master.py

# ADC 
echo " $(date +%T) - - Master ADC Test- -"
echo "ADC_Power" > $(ls /dev/ttyACM*)
sleep 3
#cat temporary.log
if [ `grep -c "Error" temporary.log` -ne '0' ];then
	grep -w "Error" temporary.log    # Display error
	displayResul 0
else
	grep -w "OK" temporary.log
	displayResul 1
fi

echo "" > temporary.log
kill -9 "${ttyACM_process}"
sleep 0.1

if (( $(cat /sys/devices/pwm-fan/tach_enable) == 0 ));then
	echo 1 >  /sys/devices/pwm-fan/tach_enable
fi
# Fan mini
echo " $(date +%T) - - Master Fan mini Test- -"
echo "Fan_mini" > $(ls /dev/ttyACM*)

echo 10 >  /sys/devices/pwm-fan/target_pwm
sleep 5

speed=$(cat /sys/devices/pwm-fan/rpm_measured)
echo 100 >  /sys/devices/pwm-fan/target_pwm
sleep 5
echo  $speed $(cat /sys/devices/pwm-fan/rpm_measured)
if (( $speed < $(cat /sys/devices/pwm-fan/rpm_measured)));then
	displayResul 1
else
	displayResul 0
fi


# Fan big
echo " $(date +%T) - - Master Fan big Test- -"
echo "Fan_big" > $(ls /dev/ttyACM*)

echo 10 >  /sys/devices/pwm-fan/target_pwm
sleep 5

speed=$(cat /sys/devices/pwm-fan/rpm_measured)
echo 100 >  /sys/devices/pwm-fan/target_pwm
sleep 5
echo  $speed $(cat /sys/devices/pwm-fan/rpm_measured)
if (( $speed < $(cat /sys/devices/pwm-fan/rpm_measured)));then
	displayResul 1
else
	displayResul 0
fi
echo 10 >  /sys/devices/pwm-fan/target_pwm

:<<!
# Get master ip
ifconfig eth0 > ip.log
echo $(sed -n '2,2p' ip.log | cut -c 14-28) > ip.log   

# Start Worker test
stty -F /dev/ttyUSB0 raw speed 115200
stty -F /dev/ttyUSB0 raw speed 115200

# echo "" > temporary.log
# cat $(ls /dev/ttyS0) >> temporary.log &
# tttyS0_process=$!
# pkill -9 "${tttyS0_process}"

# 
echo "Worker start" >> ip.log
echo $(cat ip.log) > /dev/ttyUSB0    #seed ip
#iperf3 -s -D -i 1
sleep 30
#pkill iperf3
!
sleep 10

# Worker report
for loop  in 1 2 3
do 
	ls Worker* > temporary.log
	if [ `grep -c "Worker${loop}" temporary.log` -ne '0' ];then
		if (( ${loop} == 1 )); then
			echo " $(date +%T) - - Master Eth Test- -"
			displayResul 1
		fi
		
		echo " $(date +%T) - - Worker${loop} Test- -"
		cat Worker${loop}.log > temporary.log
		if [ `grep -c "Error" temporary.log` -ne '0' ];then
			grep -w "Error" Worker${loop}.log    # Display error
			grep -w "OK" Worker${loop}.log
			displayResul 0
		else
			grep -w "OK" Worker${loop}.log
			displayResul 1
		fi
	else
		echo " $(date +%T) - - Worker${loop} - -"
		displayResul 0
	fi
done

rm -rf Worker*

