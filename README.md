# Rock64 Hass.io Installer
Setup an I2C LCD screen(16x4) on a Rock64 running a debian-OS and the Home-Assistant Application  
For Example mrfixit2001 maintains a great debian release for Rock64 here:  
https://github.com/mrfixit2001/debian_builds/releases or https://wiki.pine64.org/index.php/ROCK64_Software_Release#Debian_by_mrfixit2001  
And AyuFan has great ubuntu based releases here:  
https://github.com/ayufan-rock64 or https://wiki.pine64.org/index.php/ROCK64_Software_Release#Ubuntu_18.04_Bionic  
If you use AyuFan's release don't forget to run sudo apt-get install linux-rock64 -y after booting  
Also you can use dietpi as a base OS if you prefer and still install this package instead of the one available within the dietpi software center.  
The primary difference is that this script installs Hassio with the supervisor where the dietpi software center only installs Hassio.
https://dietpi.com/downloads/images/DietPi_Rock64-ARMv8-Buster.7z


This project came out of repurposing a Iconikal Rockchip SBC Recon Sentinel which includes the following:  
1. Rock64 SBC (1G of RAM)  
2. 16X4 LCD screen with I2C driver module  
3. 16Gb MicroSD card  
4. 5V 3A 1.35mm Power Adapter  

This board will be running Home-Assistant application which you can research here:  
https://www.home-assistant.io/

Information about the Hass.io supervisor plugin can be found here:  
https://www.home-assistant.io/hassio/

The modules and scripts included here are to setup the LCD screen to output the running status of the Docker service and the IP address of the device.  It will also install the Docker subsystem and pull all needed modules to setup the Home Assistant/hassio supervisor.


# Installation Instructions
Run the following commands on the cli interface:  
1. cd ~/
2. git clone --depth=1 "https://github.com/Griffen8280/Rock64HASSIOSetup.git"
3. cd Rock64HASSIOSetup
4. chmod +x install.sh (Note this step may not be needed, run ls -al before this command to see if it is executable already)
5. You may need to open the install.sh script and adjust the line to specify what machine you are installing to.  Starting at line 42 there is a brief explanation and table of what machine types can be used.  Default for this script is to install to Raspberry-pi 3 64bit/Rock64.
6. sudo ./install.sh
7. At the end of the install it should give you the url to access the install (http://192.168.XXX.XXX:8123)
8. Proceed to the website and let Home Assistant finish setting up.
9. Once it gets to the primary user creation screen you can either proceed or reboot to get the LCD screen working

This process may take a bit of time to complete, keep a video going in another tab while you wait :).
