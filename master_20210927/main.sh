#!/bin/bash

function displayResul(){
    if [ "$1" -eq 1 ]; then
        echo    " -     -       -       -       -       -"
        echo    " -                                     -"
        echo -e " -\033[32m             succssed                \033[0m-"
        echo    " -                                     -"
        echo    " -     -       -       -       -       -"
    else
        echo    " -     -       -       -       -       -"
        echo    " -                                     -"
        echo -e " -\033[31m              failed                 \033[0m-"
        echo    " -                                     -"
        echo    " -     -       -       -       -       -"

    fi
}


stty -F $(ls /dev/ttyACM0) raw speed 115200
stty -F $(ls /dev/ttyACM0) raw speed 115200
stty -F $(ls /dev/ttyACM0) raw speed 115200



# Background temporary
echo "" > temporary.log
cat $(ls /dev/ttyACM0) >> temporary.log &
ttyACM_process=$!

python3 master.py

# ADC 
echo " $(date +%T) - - Master ADC Test- -"
echo "ADC_Power" > $(ls /dev/ttyACM0)
sleep 3
cat temporary.log
if [ `grep -c "Error" temporary.log` -ne '0' ];then
#	grep -w "Error" temporary.log    # Display error
	displayResul 0
else
#	grep -w "OK" temporary.log
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
echo "Fan_mini" > $(ls /dev/ttyACM0)

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
echo "Fan_big" > $(ls /dev/ttyACM0)

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


# UART
echo " $(date +%T) - - Master UART Test- -"
stty -F /dev/ttyUSB0 raw speed 115200
stty -F /dev/ttyUSB0 raw speed 115200

cat /dev/ttyUSB0 > temporary.log &
ttyUSB0_process=$!
echo "\r\n" > /dev/ttyUSB0
sleep 2
if [ `grep -c "Password" temporary.log` -ne '0' ];then
	displayResul 1
else
	displayResul 0
fi
kill -9 "${ttyUSB0_process}"


sleep 3

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
		cat Worker${loop}.log
		cat Worker${loop}.log > temporary.log
		if [ `grep -c "Error" temporary.log` -ne '0' ];then
			displayResul 0
		else
			displayResul 1
		fi
	else
		echo " $(date +%T) - - Worker${loop} - -"
		displayResul 0
	fi
done

rm -rf Worker*

