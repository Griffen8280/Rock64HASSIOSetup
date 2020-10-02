#! /bin/bash

#Check for root and use it when needed
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

#Update the system cache and install needed dependancies for python
$SUDO apt update && $SUDO apt install python-smbus git python3 i2c-tools -y

#Get the Rock64 GPIO drivers and install them
git clone --depth=1 "https://github.com/Leapo/Rock64-R64.GPIO.git"
cd Rock64-R64.GPIO
mv R64 ../
cd ..
rm -Rf Rock64-R64.GPIO
cd R64
chmod +x *.py
cd GPIO
chmod +x *.py
cd ../..

#Setup a check to see if python2 and python3 are installed.
$SUDO cp -R R64 /usr/local/lib/python2.7/dist-packages/
echo "Rock64 GPIO should now be installed"

#Setup a check to see if docker is already installed then skip setup if not needed
#Setup the docker subsystem and install Home Assistant/Hass.io Supervisor
$SUDO apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common network-manager -y
curl -fsSL https://download.docker.com/linux/debian/gpg | $SUDO apt-key add -
$SUDO add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
$SUDO apt update
$SUDO apt install -y docker-ce
sleep 3s
curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh | bash -s
