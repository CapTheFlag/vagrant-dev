#!/bin/bash

#
# Script to start and stop xDebug
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# =============================================================================

# ADD HERE THE PATHS TO OTHER LOG FILES as LOGS_LIST=( path/path1/file.log path/path2/file.log )
LOGS_LIST=(  )

# =============================================================================

REAL_PATH=$(readlink -m "$BASH_SOURCE")     # echo $REAL_PATH
FOLDER_PATH=${REAL_PATH%/*}                 # echo $FOLDER_PATH

. ${FOLDER_PATH}/../../settings.sh

for FILE in ${FILES[@]}; do
    LOGS_LIST="${LOGS_LIST} -I ${FILE}"
done

multitail /var/log/apache2/error.log -I /var/log/apache2/error.${PROJECT_NAME}.log ${LOGS_LIST}
