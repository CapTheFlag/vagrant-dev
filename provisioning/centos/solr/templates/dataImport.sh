#!/bin/bash

#
# Script to prevent stacking of SOLR dataimport requests
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

LOG_FILE="/opt/solr/dataImport.log"
exec >> $LOG_FILE  2>&1

if [ "$1" == "h" -o  "$1" == "help" -o $# -ne 2 ]; then
    echo -e "\033[33m Usage:  \033[0m"
    echo -e "\033[33m " $0 " <dataImporterIdentifier> \"<dataImporterURL>\" \033[0m"
    echo -e "\033[33m Ex.: " $0 " testing_transactions \"http://localhost:8080/testing/transactions/transactions_index_handler?clean=true&commit=true&command=full-import&synchronous=true\" \033[0m"
    exit 0
fi


LOCK_FILE_NAME="$1.lock"

URL=$2

date=`date +"%Y-%m-%d_%H:%M:%S"`
echo
echo "$date Data Import script has started..."
echo "$date Core: $1"
echo "$date PID: $$"

if [ -f $LOCK_FILE_NAME ]
then
    PID=$(<$LOCK_FILE_NAME)
    date=`date +"%Y-%m-%d_%H:%M:%S"`
    echo "$date The SOLR core $1 is already being updated by PID $PID. Request aborted."
    exit 1
fi

date=`date +"%Y-%m-%d_%H:%M:%S"`
echo "$$ (started at: $date)" > $LOCK_FILE_NAME

wget -q  "$URL"
#sleep 20

rm $LOCK_FILE_NAME

date=`date +"%Y-%m-%d_%H:%M:%S"`
echo "$date The SOLR core ($1 - $$) has finished updating."
exit 0
