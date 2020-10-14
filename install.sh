#! /bin/bash

#Check for root and use it when needed
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

#Update the system cache and install needed dependancies for all this to work
$SUDO apt update && $SUDO apt install python-smbus git python3 apt-transport-https ca-certificates curl gnupg2 software-properties-common network-manager apparmor avahi-daemon -y

#Prep and copy the LCD script to bin
chmod +x display_IP.py
chmod +x disp_shutdown.py
$SUDO cp display_IP.py /bin
$SUDO cp disp_shutdown.py /bin
$SUDO cp screenstartup.service /lib/systemd/system
$SUDO chmod 644 /lib/systemd/system/screenstartup.service
$SUDO systemctl daemon-reload
$SUDO systemctl enable screenstartup.service

#Setup a check to see if docker is already installed then skip setup if not needed
#Setup the docker subsystem and install Home Assistant/Hass.io Supervisor
if ! command -v docker &> /dev/null
then
    if [ `lsb_release -cs` == "buster" ]
    then
        curl -fsSL https://download.docker.com/linux/debian/gpg | $SUDO apt-key add -
        $SUDO add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        $SUDO apt update
        $SUDO apt install -y docker-ce
        sleep 3s
    else
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO apt-key add -
        $SUDO add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        $SUDO apt update
        $SUDO apt install -y docker-ce
        sleep 3s
    fi
fi

$SUDO curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh > hassioinstaller.sh
chmod +x hassioinstaller.sh
#The following is the list of machine types you can specify and what they are for
#intel-nuc = Intel Nuc computer || odroid-c2 = The Odroid C2 or derivative machines
#odroid-n2 = Odroid-N2 or derivative machines || odroid-xu = Odroid-XU or derivative machines
#qemuarm = 32bit Arm based vm || qemuarm-64 = 64bit Arm based vm || qemux86 = 32bit x86 CPU based vm
#qemux86-64 = 64bit x86 CPU based vm || raspberrypi = Original 32bit pi || raspberrypi2 = Original 32bit pi2
#raspberrypi3 = Original 32bit pi3 || raspberrypi4 = Original 32bit pi4 || raspberrypi3-64 = Original 64bit pi3
#raspberrypi4-64 = Original 64bit pi4 || tinker = Asus Tinker board
$SUDO /bin/bash ~/Rock64HASSIOSetup/hassioinstaller.sh -m raspberrypi3-64  #For Rock64 raspberrypi3-64 will work here
echo "All done with docker container pull"
echo "Allowing initial startup to complete"
sleep 10s
echo "The LCD screen may not work until after reboot"

#reboot the machine for the tools install to take affect
#echo "Rebooting machine to finalize setup"
#$SUDO reboot  #May not be needed

