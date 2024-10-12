# Scripted interface that communicates with a FPGA using UART

import serial
import time

ser = serial.Serial(
    port = '/dev/ttyUSB0',
    baudrate=9600,
    timeout=1
)

def send(data):
    if ser.is_open:
        ser.write(data.encode())
        print("Sent: " + data)
        return data
    else:
        print("Serial port not open")
        return None

def receive():
    if ser.is_open:
        data = ser.readline()
        print("Received: " + data.decode())
        return data
    else:
        print("Serial port not open")
        return None

# Main
try:
    for i in range(5):
        time.sleep(1)
        send(input())   # send a
        send(input())   # send b
        send(input())   # send op_code
        receive()       # receive result
except serial.SerialException as e:
    print("Communication error: " + str(e))

finally:
    if ser.is_open:
        ser.close()
        print("Serial port closed")
