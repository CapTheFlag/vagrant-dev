#!/bin/bash

#
# Script to start and stop xDebug
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

fc_help(){
        echo -e "\033[33m Usage:  \033[0m"
        echo -e "\033[33m " $0 " [-h] {on|off} \033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
}

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

XDEBUG_VERSION_LIST=( 20090626 20100525 20121212 )

if [ -d /etc/php5/mods-available ]; then
    CONFIG_FILE="/etc/php5/mods-available/xdebug.ini"
else
    CONFIG_FILE="/etc/php5/conf.d/xdebug.ini"
fi

for XDEBUG_VERSION in "${XDEBUG_VERSION_LIST[@]}"; do

    if [ -d "/usr/lib/php5/${XDEBUG_VERSION}" ];then

        case "$1" in

            on|ON)
                cp -f ${CONFIG_FILE} ${CONFIG_FILE}.bkp
                sed "s@^;zend_extension=/usr/lib/php5/${XDEBUG_VERSION}/xdebug.so@zend_extension=/usr/lib/php5/${XDEBUG_VERSION}/xdebug.so@" ${CONFIG_FILE}.bkp > ${CONFIG_FILE}
                ;;

            off|OFF)
                cp -f ${CONFIG_FILE} ${CONFIG_FILE}.bkp
                sed "s@^zend_extension=/usr/lib/php5/${XDEBUG_VERSION}/xdebug.so@;zend_extension=/usr/lib/php5/${XDEBUG_VERSION}/xdebug.so@" ${CONFIG_FILE}.bkp > ${CONFIG_FILE}
                ;;

            -h)
                fc_help
                exit 0
                ;;

            *)
                fc_help
                exit 1

        esac

    fi

done

rm -f ${CONFIG_FILE}.bkp

service apache2 restart

exit 0
