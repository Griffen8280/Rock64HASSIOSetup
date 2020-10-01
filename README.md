# Rock64 Hass.io Installer
Setup an I2C LCD screen on a Rock64 running a debian-OS and the Home-Assistant Application

This project came out of repurposing a Iconikal Rockchip SBC Recon Sentinel which includes the following:
1. Rock64 SBC (1G of RAM)
2. 16X4 LCD screen with I2C driver module
3. 16Gb MicroSD card
4. 5V 3A 1.35mm Power Adapter

This board will be running Home-Assistant application which you can research here:  
https://www.home-assistant.io/

Information about the Hass.io supervisor plugin can be found here:  
https://www.home-assistant.io/hassio/

The modules and scripts included here are to setup the LCD screen to output the running status of the Home Assistant application and the IP address of the device.  It will also install the docker subsystem and pull all needed modules to setup the Home Assistant/hassio supervisor.
