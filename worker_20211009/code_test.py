import subprocess 
import datetime 
import os 
import time 
import shlex 
import serial 
from serial.tools import list_ports 
from time import sleep
import RPi.GPIO as GPIO


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
    

def WriteResult(user_str): 
	if "OK" in user_str : 
		command = "echo \"" + user_str + "\" >> " 
	elif "Error" in user_str : 
		command = "echo \"" + user_str + "\" >> " 
	else : 
		pass
        
	if timeout_command("ls /home/pi/worker/", 10) == 0: 
		if "Worker1" in str(Comunicate): 
			d_command = " Worker1.log" 
		elif "Worker2" in str(Comunicate): 
			d_command = " Worker1.log"
        	elif "Worker3" in str(Comunicate): 		
			d_command = " Worker1.log" 
		else:
			pass
	command = command + d_command
	return command

print (WriteResult("Fan OK"))

os.system("%s" %(WriteResult("Fan Error")))