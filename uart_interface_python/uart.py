# Scripted interface that communicates with a FPGA using UART

import serial
import time

ser = serial.Serial(
    port = '/dev/ttyUSB0',
    baudrate=9600,
    timeout=1,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

def send(data):
    if ser.is_open:
        ser.write(data)
        hex_data = ', '.join(f'0x{byte:02x}' for byte in data)
        print(hex_data)
        return data
    else:
        print("Serial port not open")
        return None

def receive():
    if ser.is_open:
        data = ser.readline()
        hex_data = ', '.join(f'0x{byte:02x}' for byte in data)
        print(hex_data)
        return data
    else:
        print("Serial port not open")
        return None

# Main
try:
    for i in range(5):
        time.sleep(1)
        send(b"\x01")   # send a
        #send(bytes(["0b00000001"]))   # send a
        time.sleep(1)
        send(b"\x01")   # send b
        time.sleep(1)
        send(b"\x20")   # send op_code
        time.sleep(1)
        receive()       # receive result

except serial.SerialException as e:
    print("Communication error: " + str(e))

finally:
    if ser.is_open:
        ser.close()
        print("Serial port closed")
