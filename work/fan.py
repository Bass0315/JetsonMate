import subprocess
import datetime
import os
import time
import shlex
import serial
from serial.tools import list_ports
from time import sleep
import RPi.GPIO as GPIO


result_flag = 0

#Download wifi program
def timeout_command(command, timeout):
    """
    call shell-command and either return its output or kill it
    if it doesn't normally exit within timeout seconds and return None
    """
    # if type(command) == type(''):          # Adding these two sentences will cause an error.
        # command = shlex.split(command)
    global Comunicate
    start = datetime.datetime.now()
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    resultcode = process.poll()
    while resultcode is None:
        now = datetime.datetime.now()
        if (now - start).seconds > timeout:  
            process.kill()
            return -1
        sleep(0.01)
        resultcode = process.poll()
    Comunicate = process.communicate()    
    return resultcode
    
    
def displayResult(flag):
    if flag == True:
        print (" - - - - - - - - - - - - - - - - - - - - ")
        print (" -                                     - ")
        print (" -              succssed               - ")
        print (" -                                     - ")
        print (" - - - - - - - - - - - - - - - - - - - - ")  
    else:
        print (" - - - - - - - - - - - - - - - - - - - - ")
        print (" -                                     - ")
        print (" -               failed                - ")
        print (" -                                     - ")
        print (" - - - - - - - - - - - - - - - - - - - - ") 

def FanEvent_callback(n):
    global result_flag
    result_flag += 1
    print (time.strftime(" %H:%M:%S ", time.localtime()) + str(result_flag))
    if 3 <= result_flag :
        GPIO.cleanup(17)
        if timeout_command("ls /home/pi/worker/", 10) == 0:  
            if "Worker1" in str(Comunicate):          
                os.system("echo 'Fan OK' >> Worker1.log")
            elif "Worker2" in str(Comunicate):
                os.system("echo 'Fan OK' >> Worker2.log")
            elif "Worker3" in str(Comunicate):
                os.system("echo 'Fan OK' >> Worker3.log")
            else:
                pass
            
# echo gpio12(Fan pwm), gpio17(Fan tach)
if timeout_command("ls /sys/class/gpio/", 10) == 0:  
    if "gpio12" in str(Comunicate):
        os.system("echo out > /sys/class/gpio/gpio12/direction")
    else:
        os.system("echo 12 > /sys/class/gpio/export")
        os.system("echo out > /sys/class/gpio/gpio12/direction")


GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.add_event_detect(17, GPIO.FALLING, FanEvent_callback)

os.system("echo 0 > /sys/class/gpio/gpio12/value") 
sleep(4)
os.system("echo 1 > /sys/class/gpio/gpio12/value") 

if result_flag == 0:
    if timeout_command("ls /home/pi/worker/", 10) == 0:  
        if "Worker1" in str(Comunicate):
            os.system("echo 'Fan Error' >> Worker1.log")
        elif "Worker2" in str(Comunicate):
            os.system("echo 'Fan Error' >> Worker2.log")
        elif "Worker3" in str(Comunicate):
            os.system("echo 'Fan Error' >> Worker3.log")
        else:
            pass

result_flag = 0







    
