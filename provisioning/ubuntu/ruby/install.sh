#!/bin/bash

#
# Script for instalation of an application in a vagrant VBox with ubuntu
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

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------


echo "Installing ruby ... "
apt-get install -y ruby

echo
echo "Done"
echo



exit 0
