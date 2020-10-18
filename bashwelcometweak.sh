#!/usr/bin/env bash

# This file is derived from part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to their COPYRIGHT.md file.
#
# See the LICENSE.md file at the top-level directory of their distribution at
# https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# Modified from the RetroPie project for PiHole
# Also includes the logo for PiHole for a little personalization
#

home=~/ # Primary home location

function install_bashwelcometweak() {
    remove_bashwelcometweak
    cat >> "$home/.bashrc" <<\_EOF_
# Rock64 PROFILE START
function getIPAddress() {
    local ip_route
    ip_route=$(ip -4 route get 8.8.8.8 2>/dev/null)
    if [[ -z "$ip_route" ]]; then
        ip_route=$(ip -6 route get 2001:4860:4860::8888 2>/dev/null)
    fi
    [[ -n "$ip_route" ]] && grep -oP "src \K[^\s]+" <<< "$ip_route"
}
function rock64_welcome() {
    local upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
    local secs=$((upSeconds%60))
    local mins=$((upSeconds/60%60))
    local hours=$((upSeconds/3600%24))
    local days=$((upSeconds/86400))
    local UPTIME=$(printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs")
    # calculate rough CPU and GPU temperatures:
    local cpuTempC
    local cpuTempF
    local gpuTempC
    local gpuTempF
    if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]; then
        cpuTempC=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000)) && cpuTempF=$((cpuTempC*9/5+32))
    fi
    if [[ -f "/opt/vc/bin/vcgencmd" ]]; then
        if gpuTempC=$(/opt/vc/bin/vcgencmd measure_temp); then
            gpuTempC=${gpuTempC:5:2}
            gpuTempF=$((gpuTempC*9/5+32))
        else
            gpuTempC=""
        fi
    fi
    local df_out=()
    local line
    while read line; do
        df_out+=("$line")
    done < <(df -h /)
    local rst="$(tput sgr0)"
    local fgblk="${rst}$(tput setaf 0)" # Black - Regular
    local fgred="${rst}$(tput setaf 1)" # Red
    local fggrn="${rst}$(tput setaf 2)" # Green
    local fgylw="${rst}$(tput setaf 3)" # Yellow
    local fgblu="${rst}$(tput setaf 4)" # Blue
    local fgpur="${rst}$(tput setaf 5)" # Purple
    local fgcyn="${rst}$(tput setaf 6)" # Cyan
    local fgwht="${rst}$(tput setaf 7)" # White
    local bld="$(tput bold)"
    local bfgblk="${bld}$(tput setaf 0)"
    local bfgred="${bld}$(tput setaf 1)"
    local bfggrn="${bld}$(tput setaf 2)"
    local bfgylw="${bld}$(tput setaf 3)"
    local bfgblu="${bld}$(tput setaf 4)"
    local bfgpur="${bld}$(tput setaf 5)"
    local bfgcyn="${bld}$(tput setaf 6)"
    local bfgwht="${bld}$(tput setaf 7)"
    local logo=(
        "${fgwht}@@@@@@@@@@${fgcyn}&${fgwht}@@@@@@@@@@"
        "${fgwht}@@@@@@@@${fgcyn}*****${fgwht}@@@@@@@@"
        "${fgwht}@@@@${fgblu}((((${fgblk}%${fgwht}@@@${fgblu}((((${fgwht}@@@@@"
        "${fgwht}@@@@${fgpur}#${fgblu}(((((((((((${fgwht}@@@@@"
        "${fgwht}@${fgblu}((((${fgpur}#${fgwht}@${fgblu}((((((${fgwht}@@${fgblu}((((${fgblk}&${fgwht}@"
        "${fgwht}@${fgblu}(((((${fgblk}%${fgwht}@@${fgblu}((${fgblk}%${fgwht}@@${fgblu}(((((${fgblk}&${fgwht}@"
        "${fgwht}@@@${fgblu}((((((((((((((${fgblk}&${fgwht}@@@"
        "${fgwht}${fgpur}#####${fgwht}@@${fgpur}#${fgblu}(((((${fgwht}@@${fgpur}#####${fgwht}@"
        "${fgwht}@${fgpur}######${fgwht}@@${fgpur}##${fgwht}@@${fgblk}%${fgpur}#####${fgwht}@@"
        "${fgwht}@@@${fgpur}##############${fgwht}@@@@"
        "${fgwht}@@@@@@@@@${fgpur}##${fgblk}%${fgwht}@@@@@@@@@"
        "${fgwht}@@@@@@@@@${fgpur}##${fgwht}@@@@@@@@@@"
        )
    local out
    local i
    for i in "${!logo[@]}"; do
        out+="  ${logo[$i]}  "
        case "$i" in
            0)
                out+="${fgcyn}$(date +"%A, %e %B %Y, %X")"
                ;;
            1)
                out+="${fgcyn}$(uname -srmo)"
                ;;
            3)
                out+="${fgcyn}${df_out[0]}"
                ;;
            4)
                out+="${fgwht}${df_out[1]}"
                ;;
            5)
                out+="${fgblu}Uptime.............: ${UPTIME}"
                ;;
            6)
                out+="${fgblu}Memory.............: $(grep MemFree /proc/meminfo | awk {'print $2'})kB (Free) / $(grep MemTotal /proc/meminfo | awk {'print $2'})kB (Total)"
                ;;
            7)
                out+="${fgblu}Running Processes..: $(ps ax | wc -l | tr -d " ")"
                ;;
            8)
                out+="${fgblu}IP Address.........: $(getIPAddress)"
                ;;
            9)
                out+="Temperature........: CPU: ${cpuTempC}°C/${cpuTempF}°F GPU: ${gpuTempC}°C/${gpuTempF}°F"
                ;;
            10)
                out+="${fgwht}Rock64 SBC Info, http://wiki.pine64.org/index.php?title=ROCK64"
                ;;
        esac
        out+="${rst}\n"
    done
    echo -e "\n$out"
}
rock64_welcome
# ROCK64 PROFILE END
_EOF_


}

function remove_bashwelcometweak() {
    sed -i '/ROCK64 PROFILE START/,/ROCK64 PROFILE END/d' "$home/.bashrc"
}

function gui_bashwelcometweak() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Bash Welcome Tweak Configuration" 22 86 16)
    local options=(
        1 "Install Bash Welcome Tweak"
        2 "Remove Bash Welcome Tweak"
    )
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                install_bashwelcometweak
                dialog --title Complete --msgbox "Installed Bash Welcome Tweak." 22 30
                ;;
            2)
                remove_bashwelcometweak
                dialog --title Complete --msgbox "Removed Bash Welcome Tweak." 22 30
                ;;
        esac
    fi
}

gui_bashwelcometweak
