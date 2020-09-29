#! /bin/bash

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
$SUDO apt update && $SUDO apt install python-smbus git python3 -y

git clone --depth=1 "https://github.com/Leapo/Rock64-R64.GPIO.git"

cd Rock64-R64.GPIO
mv R64 ../
cd ..
rm -Rf Rock64-R64.GPIO

echo "Rock64 GPIO should now be installed, now checking revision"

echo "Should be now all finished. Please press any key to now reboot. After rebooting run"

read -n1 -s
$SUDO reboot
