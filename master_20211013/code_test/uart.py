import serial
import time

port = serial.Serial("/dev/ttyS0", baudrate = 9600, timeout = 2)

port.write("Test data")

time.sleep(1)

rcv = port.read(9)

if rcv == "Test data" :
    print "OK"
else :
    print "Error"

print "received", rcv