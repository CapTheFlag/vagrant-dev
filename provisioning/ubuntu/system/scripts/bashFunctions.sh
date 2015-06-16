#!/bin/bash

#
# Script with useful functions
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

#
# Documentation:
#   - 2D arrays: http://stackoverflow.com/questions/16487258/how-to-declare-2d-array-in-bash
#   - Fct return a value: http://www.linuxjournal.com/content/return-values-bash-functions
#

# ==================================================================
#
# PROPERTIES
#
# ------------------------------------------------------------------
# some colors for message display
# WIPE="\033[1m\033[0m"
# RED='\E[1;31m'

# BLUE='\E[1;34m'
# YELLOW='\E[1;33m'
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

#
# function to run when an error occurs
#
function on_error {
    if [ ! $? -eq 0 ]; then
        echo
        echo "An error occurred during:"
        echo -e "   ${Red}${PHASE}${Color_Off}"
        echo "For detailed errors, see above"
        echo "Aborting script"
        echo
        exit 1
    fi
}

#
# function to display the description of the current phase
#
function phase_start {
    echo
    echo -e "${BIYellow}Starting phase:   ${PHASE}${Color_Off}"
    echo
}

#
# function to notify the end of the current phase
#
function phase_finish ${APP_NAME} {
    echo
    echo -e "${BIBlue}Finished phase:   ${PHASE}${Color_Off}"
    echo
}

#
#
#
function update_installed {
    if [ -f /var/log/IDW/installed_apps.array.sh ]; then
        # load list
        . /var/log/IDW/installed_apps.array.sh
        INSTALLED["$1"]=1
    else
        mkdir -p /var/log/IDW/
        touch /var/log/IDW/installed_apps.array.sh
        declare -A INSTALLED=(["$1"]="1")
    fi

    # save list
    set | grep ^INSTALLED= > /var/log/IDW/installed_apps.array.sh
    sed -i '1s/^/declare -A /' /var/log/IDW/installed_apps.array.sh

    echo "Installed apps:"
    cat /var/log/IDW/installed_apps.array.sh
}


#
# function to display the description of the current phase
# call it as: install_apps APPS[@]
#
function install_apps {
    declare -a APP_LIST=("${!1}")
    for APP in "${APP_LIST[@]}"; do

        if [ -f /var/log/IDW/installed_apps.array.sh ]; then
            # load list
            . /var/log/IDW/installed_apps.array.sh
        else
            mkdir -p /var/log/IDW/
            touch /var/log/IDW/installed_apps.array.sh
        fi

        if [[ ! ${INSTALLED["$APP"]} ]]; then
            if [ -f ${APPLICATIONS_DIR}/${APP}/install.sh ]; then
                ${APPLICATIONS_DIR}/${APP}/install.sh ${ENV} ${HOSTNAME}
            else
                echo "Application '${APP}' install script not found (${APPLICATIONS_DIR}/${APP}/install.sh)."
            fi
        else
            echo "Application '${APP}' has already been ran. Will not run it again."
            echo "Installed apps:"
            cat /var/log/IDW/installed_apps.array.sh
        fi

    done
}

#
#
#
function getOS_name {
    OS_ID=`lsb_release -si`

    # uname -a
    # cat /etc/*-release

    echo ${OS_ID}
}

#
#
#
function getOS_version {
    OS_VERSION=`lsb_release -sr`

    echo ${OS_VERSION}
}


#
# Replaces text in a file
# Synopsis: replaceText <filepath> <from> <to>
#
function replaceText {

    FILE_PATH=$1
    FROM=$2
    TO=$3

    cp -f ${FILE_PATH} ${FILE_PATH}.bkp
    sed "s@${FROM}@${TO}@" ${FILE_PATH}.bkp > ${FILE_PATH}
}

#
# Sets the system timezone
# Synopsis: setTimezone "Europe/Amsterdam"
#
function setTimezone {

    TIME_ZONE=$1

    echo $TIME_ZONE > /etc/timezone

    sudo ln -sf /usr/share/zoneinfo/${TIME_ZONE} localtime
    dpkg-reconfigure -f noninteractive tzdata

    echo "export TZ=${TIME_ZONE}" >> /etc/bash.bashrc
    export TZ=${TIME_ZONE}
}

#
# Logs a message to a file
# Synopsis: log "message" "file_path"
#
function log {

    MSG=$1
    LOG_FILE=$2

    echo "[" $(date +"%Y-%m-%d %T") "]  " ${MSG} >> ${LOG_FILE}
}

# rename a file, removing everyting betweent the first 6 characters and the last 7 characters
# rename -v 's/^(A_\d{3})[a-zA-Z0-9_-]+_(\d{3,4}).mp4/$1_$2.mp4/' *.mp4

function renameFiles {
    src_path=/mnt/beeldengeluid-mp4/secure
    for i in $(find ${src_path} -type d -name "A_*")
    do
        cd $i
        pwd
        rename -v 's/^(A_\d{3})[a-zA-Z0-9_-]+_(\d{3,4}).mp4/$1_$2.mp4/' *.mp4 | rm *.ismv | rm *.ism
    done
}

function user_exists {
    if getent passwd $1 > /dev/null 2>&1; then
        echo "1"
    else
        echo "0"
    fi
}

function in_string {
    NEEDLE=$1
    HAYSTACK=$2
    if [[ *${NEEDLE}* == ${HAYSTACK} ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# Bash does not support multidimensional arrays.
# You can simulate it though by using indirect expansion:
#
# #!/bin/bash
# declare -a a0=(1 2 3 4)
# declare -a a1=(5 6 7 8)
# var="a1[1]"
# echo ${!var}  # outputs 6
#
# Assignments are also possible with this method:
#
# let $var=55
# echo ${a1[1]}  # outputs 55
#
# To read such an array from a file, with each row on a line, and values delimited by space, use this:
#
# idx=0
# while read -a a$idx; do
#     let idx++;
# done </tmp/some_file
#
# To declare and initialize a0..a3[0..4] to 0, you could run:
#
# for i in {0..3}; do
#     eval "declare -a a$i=( $(for j in {0..4}; do echo 0; done) )"
# done
#
