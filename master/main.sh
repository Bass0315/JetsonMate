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

stty -F $(ls /dev/ttyACM*) raw speed 115200
stty -F $(ls /dev/ttyACM*) raw speed 115200
stty -F $(ls /dev/ttyACM*) raw speed 115200



# Background temporary
echo "" > temporary.log
cat $(ls /dev/ttyACM*) >> temporary.log &
temporary_process=$!

python3 master.py

# ADC 
echo " $(date +%T) - - Master ADC Test- -"
echo "ADC_Power" > $(ls /dev/ttyACM*)
sleep 3
cat temporary.log
echo "" > temporary.log


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

kill -9 "$temporary_process"


# Get master ip
ifconfig eth0 > ip.log
echo $(sed -n '2,2p' ip.log | cut -c 14-28) > ip.log   #get ip

# echo $(cat ip.log) > $(sudo ls /dev/ttyUSB*)    #seed ip