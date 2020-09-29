#! /bin/bash

SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi
$SUDO apt update && $SUDO apt install python27
