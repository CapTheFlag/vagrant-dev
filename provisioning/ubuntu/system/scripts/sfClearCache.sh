#!/bin/bash

#
# Script to clean the symfony cache
#
# @author Herberto Graca <herberto@videodock.com>

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

PROJECT_PATH=''

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

fc_help(){
        echo -e "\033[33m Usage:  \033[0m"
        echo -e "\033[33m " $0 " [-h] <project_name> \033[0m"
        echo -e "\033[33m The project name is the folder name as in '/var/www/<project_name>' \033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
}

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

if [ $# -eq 1 ] && [ -d "/var/www/${1}/" ]; then

    # if [ ! -d "/tmp/${1}/" ]; then
    #     mkdir -p --mode=777 /tmp/${1}/logs
    #     mkdir -p --mode=777 /tmp/${1}/cache/dev
    #     mkdir -p --mode=777 /tmp/${1}/cache/prod
    # fi

    PROJECT_APP_FOLDER="/var/www/${1}/app"
    CACHE_LOGS_PARENT_FOLDER="${PROJECT_APP_FOLDER}"

    rm -rf ${PROJECT_APP_FOLDER}/cache/*

    php ${PROJECT_APP_FOLDER}/console cache:clear --env=dev
    php ${PROJECT_APP_FOLDER}/console cache:clear --env=prod
    # APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd' | grep -v root | head -1 | cut -d\  -f1`
    # sudo setfacl -R -m u:$APACHEUSER:rwX -m u:`whoami`:rwX ${CACHE_LOGS_PARENT_FOLDER}/cache ${CACHE_LOGS_PARENT_FOLDER}/logs
    # sudo setfacl -dR -m u:$APACHEUSER:rwX -m u:`whoami`:rwX ${CACHE_LOGS_PARENT_FOLDER}/cache ${CACHE_LOGS_PARENT_FOLDER}/logs

elif [[ -f "app/console" ]]; then

    rm -rf app/cache/*

    php app/console cache:clear --env=dev
    php app/console cache:clear --env=prod

else

    if [ "$1" == "-h" ]; then

        fc_help
        exit 0

    else

        echo "No such project."
        echo
        fc_help
        exit 1

    fi

fi
