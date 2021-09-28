import subprocess
import datetime
import os
import time
import shlex
import serial
from serial.tools import list_ports
from time import sleep
#from FileControl import fileOperate
 
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


# Master USB2.0
print (time.strftime(" %H:%M:%S ", time.localtime()) + "- - Master USB2.0 Test- -") 
if timeout_command("lsusb", 10) == 0:  
    if "2886:800b" in str(Comunicate) and "10c4:ea60" in str(Comunicate):
        displayResult(True)
    else:
        displayResult(False)
else:
    displayResult(False)

# Master USB3.0
print (time.strftime(" %H:%M:%S ", time.localtime()) + "- - Master USB3.0 Test- -") 
if timeout_command("ls /dev/", 10) == 0:  
    if "sd" in str(Comunicate):
        displayResult(True)
    else:
        displayResult(False)
else:
    displayResult(False)

# Master IIC
print (time.strftime(" %H:%M:%S ", time.localtime()) + "- - Master IIC Test- -") 
if timeout_command("i2cdetect -y 2", 10) == 0:  
    if "50: 50" in str(Comunicate):
        displayResult(True)
    else:
        displayResult(False)
else:
    displayResult(False)



    
