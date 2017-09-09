#!/usr/bin/python2
from sys import exit, argv
import time
import serial


def main():
    ser = serial.Serial('/dev/ttyACM0')
    # ser = serial.Serial('/dev/tty.usbserial')
    time.sleep(2)
    ser.write(b'U')
    # ser.write(argv[1])
    ser.close()
    return 0

if __name__ == '__main__':
    exit(main())
