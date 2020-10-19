#! /bin/bash

#Check for root and escalate if not
if [ "$EUID" != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

function run_installer(){

    #Update the system cache and install needed dependancies for all this to work
    apt update && $SUDO apt install python-smbus git python3 apt-transport-https ca-certificates curl gnupg2 software-properties-common network-manager apparmor avahi-daemon -y

    #Create the choice array and get the choice from the user for a variable
    ch=("intel-nuc" "Intel Nuc computer" "odroid-c2" "The Odroid C2 or derivative machines" "odroid-n2"
    "Odroid-N2 or derivative machines" "odroid-xu" "Odroid-XU or derivative machines" "qemuarm"
    "32bit Arm based vm" "qemuarm-64" "64bit Arm based vm" "qemux86" "32bit x86 CPU based vm" "qemux86-64"
    "64bit x86 CPU based vm" "raspberrypi" "Original 32bit pi" "raspberrypi2" "Original 32bit pi2" "raspberrypi3"
    "Original 32bit pi3" "raspberrypi4" "Original 32bit pi4" "raspberrypi3-64" "Original 64bit pi3"
    "raspberrypi4-64" "Original 64bit pi4" "tinker" "Asus Tinker board")
    var=$( dialog --stdout --title "Computer Type" --radiolist "What type of computer do you have?" 35 60 15 \
    "${ch[0]}" "${ch[1]}" OFF \
    "${ch[2]}" "${ch[3]}" OFF \
    "${ch[4]}" "${ch[5]}" OFF \
    "${ch[6]}" "${ch[7]}" OFF \
    "${ch[8]}" "${ch[9]}" OFF \
    "${ch[10]}" "${ch[11]}" OFF \
    "${ch[12]}" "${ch[13]}" OFF \
    "${ch[14]}" "${ch[15]}" OFF \
    "${ch[16]}" "${ch[17]}" OFF \
    "${ch[18]}" "${ch[19]}" OFF \
    "${ch[20]}" "${ch[21]}" OFF \
    "${ch[22]}" "${ch[23]}" OFF \
    "${ch[24]}" "${ch[25]}" OFF \
    "${ch[26]}" "${ch[27]}" OFF \
    "${ch[28]}" "${ch[29]}" OFF )
    
    #Prep and copy the LCD script to bin
    chmod +x display_IP.py
    chmod +x disp_shutdown.py
    cp display_IP.py /bin
    cp disp_shutdown.py /bin
    cp screenstartup.service /lib/systemd/system
    chmod 644 /lib/systemd/system/screenstartup.service
    systemctl daemon-reload
    systemctl enable screenstartup.service

    #Setup a check to see if docker is already installed then skip setup if not needed
    #Setup the docker subsystem and install Home Assistant/Hass.io Supervisor
    if ! command -v docker &> /dev/null
    then
        if [ `lsb_release -cs` == "buster" ]
        then
            curl -fsSL https://download.docker.com/linux/debian/gpg | $SUDO apt-key add -
            add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            apt update
            apt install -y docker-ce
            sleep 3s
        else
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO apt-key add -
            add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            apt update
            apt install -y docker-ce
            sleep 3s
        fi
    fi

    echo "Allow for Docker services to start"
    sleep 5s
    curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh > hassioinstaller.sh
    chmod +x hassioinstaller.sh
    #The following is the list of machine types you can specify and what they are for
    #intel-nuc = Intel Nuc computer || odroid-c2 = The Odroid C2 or derivative machines
    #odroid-n2 = Odroid-N2 or derivative machines || odroid-xu = Odroid-XU or derivative machines
    #qemuarm = 32bit Arm based vm || qemuarm-64 = 64bit Arm based vm || qemux86 = 32bit x86 CPU based vm
    #qemux86-64 = 64bit x86 CPU based vm || raspberrypi = Original 32bit pi || raspberrypi2 = Original 32bit pi2
    #raspberrypi3 = Original 32bit pi3 || raspberrypi4 = Original 32bit pi4 || raspberrypi3-64 = Original 64bit pi3
    #raspberrypi4-64 = Original 64bit pi4 || tinker = Asus Tinker board
    /bin/bash ~/Rock64HASSIOSetup/hassioinstaller.sh -m $var  #For Rock64 raspberrypi3-64 will work here
    echo "All done with docker container pull"
    echo "Allowing initial startup to complete"
    sleep 10s
    echo "The LCD screen may not work until after reboot"

    #reboot the machine for the tools install to take affect
    #echo "Rebooting machine to finalize setup"
    #$SUDO reboot  #May not be needed
}

function gui_installer() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Bash Welcome Tweak Configuration" 22 86 16)
    local options=(
        1 "Install Bash Welcome Tweak"
        2 "Remove Bash Welcome Tweak"
        3 "Install Hass.io + Supervisor"
    )
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                chmod +x installbashwelcometweak.sh
                ./installbashwelcometweak.sh
                dialog --title Complete --msgbox "Installed Bash Welcome Tweak." 22 30
                gui_installer;;
            2)
                chmod +x removebashwelcometweak.sh
                ./removebashwelcometweak.sh
                dialog --title Complete --msgbox "Removed Bash Welcome Tweak." 22 30
                gui_installer;;
            3)
                run_installer
                dialog --title Complete --msgbox "Installed Hassio!" 22 30
                gui_installer;;
        esac
    fi
}
gui_installer
