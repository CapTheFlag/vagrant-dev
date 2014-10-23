#!/bin/bash

#
# Script for instalation of ant in a vagrant VBox with ubuntu
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

DEPENDENCIES=( jdk7 )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------


echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

apt-get -y install ant

# ------------------------------------------------------------------



exit 0
