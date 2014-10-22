#!/bin/bash

FILE_PATH='tests/_log/coverage.xml'
FROM='/home/herberto/Development/workspace/www/'
TO='/var/www/'
VAGRANT_SERVER=$1
PROJECT_NAME=$2
CODECEPTION_PARAMS=$3

cd ${FROM}/${PROJECT_NAME}
vagrant ssh ${VAGRANT_SERVER} -c "

cd /var/www/${PROJECT_NAME}

sudo -u www-data php bin/codecept run ${CODECEPTION_PARAMS} --html --xml --no-colors --coverage

cp -f ${FILE_PATH} ${FILE_PATH}.bkp
sed \"s@${FROM}@${TO}@\" ${FILE_PATH}.bkp > ${FILE_PATH}
rm -f ${FILE_PATH}.bkp
"
