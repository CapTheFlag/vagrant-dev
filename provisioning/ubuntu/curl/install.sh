#!/bin/bash

#
# Script for instalation of php in a vagrant VBox with ubuntu
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../settings.sh

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    ENV=$1
fi

PHASE="CURL"
DEPENDENCIES=(  )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

phase_start

echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

apt-get install -y curl libcurl3 libcurl3-dev php5-curl

update_installed 'curl'

phase_finish

exit 0
