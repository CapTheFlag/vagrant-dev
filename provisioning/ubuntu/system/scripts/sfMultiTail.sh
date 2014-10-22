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
        echo -e "\033[33m " $0 " [-h] <project_name> \033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
}


fc_get_logs_filepaths(){
    PROJECT_NAME=$1
    LOG_FOLDER="/var/www/${PROJECT_NAME}/app/logs"

    FILES=`find ${LOG_FOLDER} -type f -name *.log`
    LOGS_LIST=""

    for FILE in ${FILES[@]}; do
        LOGS_LIST="${LOGS_LIST} -I ${FILE}"
    done

    echo ${LOGS_LIST}
}



# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

if [ $# -eq 0 ]; then
    fc_help
    exit 1
fi


case "${1}" in

        -h)
            fc_help
            exit 0
            ;;

        *)
            PROJECT_NAME=$1
            LOGS_LIST=$(fc_get_logs_filepaths ${PROJECT_NAME})
            echo "multitail /var/log/apache2/error.log -I /var/log/apache2/error.${PROJECT_NAME}.log ${LOGS_LIST}"
            multitail /var/log/apache2/error.log -I /var/log/apache2/error.${PROJECT_NAME}.log ${LOGS_LIST}
esac
