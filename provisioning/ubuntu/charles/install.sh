#!/bin/bash

#
# Script for instalation of charles proxy
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

PHASE="CHARLES-PROXY"
DEPENDENCIES=( )

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

echo
echo "Installing ${PHASE} ... "
echo

wget -q -O - http://www.charlesproxy.com/packages/apt/PublicKey | sudo apt-key add -
echo "
deb http://www.charlesproxy.com/packages/apt/ charles-proxy main
" >> /etc/apt/sources.list

apt-get update
apt-get install -y charles-proxy

# ------------------------------------------------------------------

update_installed ${PHASE}

phase_finish

exit 0