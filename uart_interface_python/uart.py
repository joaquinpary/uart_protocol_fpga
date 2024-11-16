# Scripted interface that communicates with a FPGA using UART

import serial
import time

ser = serial.Serial(
    port = '/dev/ttyUSB1',
    baudrate=9600,
    timeout=1,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

def send(data):
    if ser.is_open:
        ser.write(data)
        bin_data = ', '.join(f'0b{byte:08b}' for byte in data)
        print(bin_data)
        return data
    else:
        print("Serial port not open")
        return None

def receive():
    if ser.is_open:
        data = ser.readline()
        bin_data = ', '.join(f'0b{byte:08b}' for byte in data)
        print("Result: ", bin_data)
        return data
    else:
        print("Serial port not open")
        return None

def operation(a, b, op_code):
    print("DATA")
    send(a)
    send(b)
    
    match op_code:
        case 'add':
            print("ADD")
            send(b"\x20")
        case 'sub':
            print("SUB")
            send(b"\x22")
        case 'and':
            print("AND")
            send(b"\x24")
        case 'or':
            print("OR")
            send(b"\x25")
        case 'xor':
            print("XOR")
            send(b"\x26")
        case 'sra':
            print("SRA")
            send(b"\x03")
        case 'srl':
            print("SRL")
            send(b"\x02")
        case 'nor':
            print("NOR")
            send(b"\x27")
        case _:
            print("Invalid operation code")
            send(b"\x00")
    receive()
    print("")
    
# Main
try:
    operation(b"\x01", b"\x02", "add")
    operation(b"\x01", b"\x02", "sub")
    operation(b"\x11", b"\x12", "and")
    operation(b"\x03", b"\xa5", "or")
    operation(b"\x03", b"\x02", "xor")
    operation(b"\xf0", b"\x02", "sra")
    operation(b"\xf0", b"\x02", "srl")
    operation(b"\x01", b"\x02", "nor")

except serial.SerialException as e:
    print("Communication error: " + str(e))

finally:
    if ser.is_open:
        ser.close()
        print("Serial port closed")
