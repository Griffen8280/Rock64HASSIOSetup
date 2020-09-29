#!/usr/bin/env python

#import libraries
import lcddriver.py
import time
import datetime
import subprocess

#designate the display variable and get the IP of the machine
display = lcddriver.lcd()
IP = subprocess.check_output(["hostname","-I"]).split()[0]

#attempt to display the info
try:
    print("Writing to display")
    while True:
        display.lcd_display_string("PiHole is Running", 1)
        display.lcd_display_string(str(IP), 2)
        # Program then loops with no delay (Can be added with a time.sleep)
except KeyboardInterrupt: # If there is a KeyboardInterrupt (when you press ctrl+c), exit the program and cleanup
    print("Cleaning up!")
    display.lcd_clear()
