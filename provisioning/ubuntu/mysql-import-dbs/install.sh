#!/bin/bash

#
# Script to import DBs into mysql
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../settings.sh

DEPENDENCIES=( mysql )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------


echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

echo
echo "Importing DBs to MySQL ... "
echo

DBs_SOURCE="${ROOT_PROVISIONING}/db"

# make sure the filenames dont have spaces
find ${DBs_SOURCE} -name "* *" -type f | rename 's/ /_/g'

FILES=`find ${DBs_SOURCE} -name "*.sql" -type f -mmin +1 -print`

for FILE in ${FILES[@]}; do
    if [ -f "${FILE}" ]; then
        DB_NAME=`basename ${FILE} .sql`
        echo `date +%Y/%m/%d-%H:%M:%S` "  Importing file: ${FILE}   into DB: ${DB_NAME}"
        mysql -u root -p${MYSQL_ROOT_PASS} -e "CREATE DATABASE ${DB_NAME};"
        mysql -u root -p${MYSQL_ROOT_PASS} ${DB_NAME} < ${FILE}
    fi
done




exit 0
