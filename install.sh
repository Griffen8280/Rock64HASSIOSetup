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
revision=`python -c "import R64.GPIO as GPIO; print GPIO.RPI_REVISION"`

if [ $revision = "1" ]
then
echo "I2C Pins detected as 0"
cp installConfigs/i2c_lib_0.py ./i2c_lib.py
else
echo "I2C Pins detected as 1"
cp installConfigs/i2c_lib_1.py ./i2c_lib.py
fi
echo "I2C Library setup for this revision of Raspberry Pi, if you change revision a modification will be required to i2c_lib.py"
echo "Now overwriting modules & blacklist. This will enable i2c Pins"
cp installConfigs/modules /etc/
cp installConfigs/raspi-blacklist.conf /etc/modprobe.d/
printf "dtparam=i2c_arm=1\n" >> /boot/config.txt


echo "Should be now all finished. Please press any key to now reboot. After rebooting run"
echo "'sudo python demo_lcd.py' from this directory"
read -n1 -s
$SUDO reboot
