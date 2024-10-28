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

def operation(a, b, op_code):
    send(a)
    send(b)
    match op_code:
        case 'add':
            send(b"\x20")
        case 'sub':
            send(b"\x22")
        case 'and':
            send(b"\x24")
        case 'or':
            send(b"\x25")
        case 'xor':
            send(b"\x26")
        case 'sra':
            send(b"\x03")
        case 'srl':
            send(b"\x02")
        case 'nor':
            send(b"\x27")
        case _:
            print("Invalid operation code")
            send(b"\x00")
    receive()

# Main
try:
    operation(b"\x01", b"\x02", "add")
    operation(b"\x01", b"\x02", "sub")
    operation(b"\x01", b"\x02", "and")
    operation(b"\x01", b"\x02", "or")
    operation(b"\x01", b"\x02", "xor")
    operation(b"\x01", b"\x02", "sra")
    operation(b"\x01", b"\x02", "srl")
    operation(b"\x01", b"\x02", "nor")

except serial.SerialException as e:
    print("Communication error: " + str(e))

finally:
    if ser.is_open:
        ser.close()
        print("Serial port closed")
