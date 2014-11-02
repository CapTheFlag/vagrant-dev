#!/bin/bash

#
# Script to monitor all files in all given folders
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
        echo -e "\033[33m " $0 " [-h] <folder_name> [folder_name ... ]\033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
}


fc_get_folders_logs_filepaths(){
    LOG_FOLDER_LIST="$@"

    FILES=`find ${LOG_FOLDER} -type f -name *.log`
    FULL_LOGS_LIST=""

    for FOLDER in ${LOG_FOLDER_LIST[@]}; do
        NEW_LOGS_LIST=$(fc_get_logs_filepaths ${FOLDER})
        FULL_LOGS_LIST="${FULL_LOGS_LIST} ${NEW_LOGS_LIST}"
    done


    echo ${FULL_LOGS_LIST}
}

fc_get_logs_filepaths(){
    LOG_FOLDER=$1

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
            FINAL_LOGS_LIST=$(fc_get_folders_logs_filepaths "$@")
            FINAL_LOGS_LIST=${FINAL_LOGS_LIST:3}
            echo "multitail ${FINAL_LOGS_LIST}"
            multitail ${FINAL_LOGS_LIST}
esac
